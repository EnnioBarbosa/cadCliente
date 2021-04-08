unit uEmail;

interface

uses
  Messages, SysUtils, Classes, IdBaseComponent, IdMessage,
  IdComponent, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL,
  IdSSLOpenSSL, IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase,
  IdMessageClient, IdSMTPBase, IdSMTP, IdAttachmentFile, IdText;

//IdHTTP,

type
  TEMail = class
  private
    FPort: Integer;
    FHost: string;
    FUsername: string;
    FPassword: string;
    FFromName: string;
    FFromAddress: string;
    FAuthentication: boolean;
    FKeepConnected: boolean;
    FAuthenticationType: TIdSMTPAuthenticationType;
    FSMTP: TIdSMTP;
    FAttachment: String;
    FAttachmentBody: String;
    FIdSSLIOHandlerSocket : TIdSSLIOHandlerSocketOpenSSL;
    procedure Erro(s: string);
    procedure CheckProps;
    procedure LoadAttachment(Msg: TIdMessage);
    function GetBodyHTML(s: string; BreakLn: boolean): string;
  protected
    procedure Conecta;
    procedure Desconecta;
    property AuthenticationType: TIdSMTPAuthenticationType
                                 read FAuthenticationType write FAuthenticationType default satDefault ;
  public
    constructor Create(const AHost: string; const APort: Integer = 465;
                       const AAuthentication: boolean = True); virtual;
    destructor Destroy; override;
    // propriedades do servidor SMTP
    property Host: string read FHost write FHost;
    property Port: Integer read FPort write FPort;
    property Authentication: boolean read FAuthentication write FAuthentication;
    // propriedades da CONTA do email
    property Username: string read FUsername write FUsername;
    property Password: string read FPassword write FPassword;
    property FromName: string read FFromName write FFromName;
    property FromAddress: string read FFromAddress write FFromAddress;
    property KeepConnected: boolean read FKeepConnected write FKeepConnected default False;
    // Propriedades referente a anexos (lista de TStrings)
    property Attachment: String read FAttachment write FAttachment;
    property AttachmentBody: String read FAttachmentBody write FAttachmentBody;
    // envio
    procedure SendEmail(const AToAddresses, ASubject, ABody: string; const BreakLn: boolean = True);
  end;

function SendEmailSMTP(const AHost, AUserName, APassword,
                             AToAddresses, ASubject, ABody: string;
                             const AAttachment: String; const APort: Integer): boolean; overload;


implementation

{ TMailSender }

constructor TEMail.Create(const AHost: string; const APort: Integer = 465;
  const AAuthentication: boolean = True);
begin
  inherited Create;
  FHost := AHost;
  FPort := APort;
  FKeepConnected := False;
  FAuthentication := True;
  FAuthenticationType := satDefault;
end;

destructor TEMail.Destroy;
begin
  if Assigned(fIdSSLIOHandlerSocket) then
    FreeAndnil(fIdSSLIOHandlerSocket);

  if Assigned(FSMTP) then
  begin
    if FSMTP.Connected then
      FSMTP.Disconnect;
    FreeAndNil(FSMTP);
  end;
  inherited;
end;

procedure TEMail.Erro(s: string);
begin
  raise Exception.Create(ClassName + ': ' + s);
end;

procedure TEMail.CheckProps;
begin
  if FHost = '' then
    Erro('O Host do servidor SMTP não foi informado');
  if FPort <= 0 then
    Erro('A porta do servidor SMTP não é válida ou não foi informada');
  if Username = '' then
    Erro('A conta do servidor SMTP não foi informada');
  if FAuthentication then
    FAuthenticationType := satDefault
  else
    FAuthenticationType := satNone;
  if FFromName = '' then
    FFromName := Username;
  if FFromAddress = '' then
  begin
    if Pos('@', Username) > 0 then
      FFromAddress := Username
    else
      FFromAddress := Username + '@' + Host;
  end;
end;

procedure TEMail.Conecta;
begin
  if not Assigned(FidSSLIOHandlerSocket) then
  begin
    fIdSSLIOHandlerSocket                   := TIdSSLIOHandlerSocketOpenSSL.Create;
    fIdSSLIOHandlerSocket.SSLOptions.Method := sslvSSLv23;
    fIdSSLIOHandlerSocket.SSLOptions.Mode  := sslmClient;
  end;

  if not Assigned(FSMTP) then
    FSMTP := TIdSMTP.Create(nil);
  if not FSMTP.Connected then
  begin
    FSMTP.Host := Host;
    FSMTP.Port := Port;

    FSMTP.IOHandler := fIdSSLIOHandlerSocket;
    FSMTP.UseTLS := utUseImplicitTLS;

    FSMTP.Username := Username;
    FSMTP.AuthType := FAuthenticationType;
    FSMTP.Password := Password;
    try
      FSMTP.Connect;
    except
      on E:Exception do
        Erro('Não foi possível conectar ao servidor SMTP.' + #13#10 +
             'Mensagem recebida do servidor: ' + E.Message);
    end;
  end;
end;

procedure TEMail.Desconecta;
begin
  if FSMTP.Connected then
    FSMTP.Disconnect;
end;

function TEMail.GetBodyHTML(s: string; BreakLn: boolean): string;
const
  HTMLHeader = '<html><head></head><body>';
  HTMLFooter = '</body></html>';
  HTMLBreak  = '<br>';
  HTMLImg = 'img src="file:///';
  HTMLImg_CID = 'img src="cid:';
var
  i: Integer;
  sl: TStrings;
begin
  Result := HTMLHeader;
  sl := TStringList.Create;
  try
    sl.Text := s;
    for i := 0 to sl.Count - 1 do
    begin
      Result := Result + sl.Strings[i];
	    if BreakLn then
    	  Result := Result + HTMLBreak;
    end;
    Result := Result + HTMLFooter;
  finally
    sl.Free;
  end;
end;

procedure TEMail.LoadAttachment(Msg: TIdMessage);
var ListaArquivo: TStrings;
    I: Integer;
    PathArq, ArqName, ArqExt: String;
begin
  ListaArquivo := TStringList.Create;
  try
    if Attachment <> '' then
    begin
      ListaArquivo.Clear;
      ListaArquivo.Text := Attachment;
      for I := 0 to ListaArquivo.Count - 1 do
      begin
        PathArq := ExtractFilePath(Trim(ListaArquivo[I]));
        ArqName := ExtractFileName(Trim(ListaArquivo[I]));
        ArqExt := ExtractFileExt(ArqName);
        with TIdAttachmentFile.Create(Msg.MessageParts, PathArq+ArqName) do
        begin
          if ArqExt = 'jpg' then
            ContentType := 'image/jpeg';
          if ArqExt = 'zip' then
            ContentType := 'application/x-zip-compressed';
          FileName := ArqName;
        end;
      end;
    end;
  finally
    ListaArquivo.Free;
  end;
end;

procedure TEMail.SendEmail(const AToAddresses, ASubject, ABody: string; const BreakLn: boolean = True);
var
  Msg: TIdMessage;
  NewText: TIdText;
  Addr: string;
begin
  CheckProps;
  addr := Trim(AToAddresses);
  if Addr = '' then
    Erro('O endereço de email do destinatário não foi informado');

  Conecta;
  try
    Msg := TIdMessage.Create(nil);
    try
      with Msg do
      begin
        AttachmentEncoding := 'MIME';
        Encoding := meMIME;
        if (Attachment <> '') or (AttachmentBody <> '') then
        begin
          NewText := TIdText.Create(MessageParts,nil);
          NewText.ContentType := 'text/html';
          LoadAttachment(Msg);  // Tem de ser chamado antes do GetBodyHTML para definir os anexos;
          NewText.Body.Text := GetBodyHTML(ABody, BreakLn);
        end
        else
        begin
          ContentType := 'text/html';
          Body.Text := GetBodyHTML(ABody, BreakLn)
        end;
        Subject := ASubject;
        From.Name := FromName;
        From.Address := FromAddress;
        Recipients.EMailAddresses := Addr;
      end;
      FSMTP.Send(Msg);
    finally
      Msg.Free;
    end;
  finally
    if not FKeepConnected then
      Desconecta;
  end;
end;

// funções utilitárias

function SendEmailSMTP(const AHost, AUserName, APassword,
                             AToAddresses, ASubject, ABody, AAttachment: string;
                             const APort: Integer): boolean; overload;
var
  Email: TEMail;
begin
  Email := TEMail.Create(AHost, APort, True);
  try
    Email.Username := AUserName;
    Email.Password := APassword;
    Email.FromName := AUserName;
    Email.FromAddress := AUserName;
    Email.Attachment := AAttachment;
    Email.SendEmail(AToAddresses, ASubject, ABody, True);
    Result := True;
  finally
    Email.Free;
  end;
end;

end.
