unit uViaCep;

interface

{$M+}

uses
  System.SysUtils;

type

 TVaiCepSucess = class
 private
    flogradouro: string;
    flocalidade: string;
    fibge: string;
    fbairro: string;
    fddd: string;
    fuf: string;
    fcep: string;
    fsiafi: string;
    fcomplemento: string;
    fgia: string;
    procedure Setbairro(const Value: string);
    procedure Setcep(const Value: string);
    procedure Setcomplemento(const Value: string);
    procedure Setddd(const Value: string);
    procedure Setgia(const Value: string);
    procedure Setibge(const Value: string);
    procedure Setlocalidades(const Value: string);
    procedure Setlogradouro(const Value: string);
    procedure Setsiafi(const Value: string);
    procedure Setuf(const Value: string);
 published
   property cep : string read fcep write Setcep;
   property logradouro : string read flogradouro write Setlogradouro;
   property complemento : string read fcomplemento write Setcomplemento;
   property bairro : string read fbairro write Setbairro;
   property localidade : string read flocalidade write Setlocalidades;
   property uf : string read fuf write Setuf;
   property ibge : string read fibge write Setibge;
   property gia : string read fgia write Setgia;
   property ddd : string read fddd write Setddd;
   property siafi : string read fsiafi write Setsiafi;
 end;

  TViaCep = class
  public
    class function PesquisaCep(pCep: string; var pDados: TVaiCepSucess): Boolean;
  end;

implementation

uses
  REST.Client,
  REST.Types,
  IPPeerClient,
  REST.Json;

type
  TViaCepException = class(Exception)
  public
    constructor Create(const StatusCode: Integer; const StatusText,
      Endpoint, Body: String); overload;

  end;

  const
    VIACEP_Url = 'https://viacep.com.br/ws/%s/json/';

{ TAlfandegaCMIntegration }

class function TViaCep.PesquisaCep(pCep: string; var pDados: TVaiCepSucess): Boolean;
var
  iRESTClient: TRESTClient;
  iRESTResponse: TRESTResponse;
  iRESTRequest: TRESTRequest;
  iBaseUrl: String;
begin
  result := False;

  pCep := pCep.Trim;
  if pCep.Length <> 8 then
    Exit;

  try
    iBaseUrl := VIACEP_Url;
    iRESTClient := TRESTClient.Create(nil);
    iRESTRequest := TRESTRequest.Create(nil);
    iRESTResponse := TRESTResponse.Create(nil);
    try
      iRESTClient.ResetToDefaults;
      iBaseUrl := Format(iBaseUrl , [pCep]);

      iRESTClient.BaseURL := iBaseUrl;
      iRESTClient.Accept := 'application/json';
      iRESTRequest.Response := iRESTResponse;
      iRESTRequest.Client := iRESTClient;
      iRESTRequest.Method := TRESTRequestMethod.rmGet;
      iRESTRequest.Execute;

      if iRESTResponse.Status.Success then
      begin
        if not iRESTResponse.Content.Contains('erro') then
        begin
          pDados := TJson.JsonToObject<TVaiCepSucess>(iRESTResponse.Content);
          Result := True;
        end;
      end
      else
        raise TViaCepException.Create(iRESTResponse.StatusCode, iRESTResponse.StatusText, iBaseUrl, iRESTResponse.Content);
    finally
      iRESTClient.Free;
      iRESTRequest.Free;
      iRESTResponse.Free;
    end;
  except
    on E: Exception do
      raise Exception.Create('['+ClassName+'.IdentificaLegado]' + #13#10 + E.Message);
  end;
end;

{ TViaCepException }

constructor TViaCepException.Create(const StatusCode: Integer; const StatusText, Endpoint, Body: String);
var
  iMsg: string;
begin
  iMsg := StatusCode.ToString + ' - ' + StatusText + #13#10 + Endpoint;
  if not Body.IsEmpty then
    iMsg := iMsg + #13#10 + Body;
  inherited Create(iMsg)
end;


{ TVaiCepSucess }

procedure TVaiCepSucess.Setbairro(const Value: string);
begin
  fbairro := Value;
end;

procedure TVaiCepSucess.Setcep(const Value: string);
begin
  fcep := Value;
end;

procedure TVaiCepSucess.Setcomplemento(const Value: string);
begin
  fcomplemento := Value;
end;

procedure TVaiCepSucess.Setddd(const Value: string);
begin
  fddd := Value;
end;

procedure TVaiCepSucess.Setgia(const Value: string);
begin
  fgia := Value;
end;

procedure TVaiCepSucess.Setibge(const Value: string);
begin
  fibge := Value;
end;

procedure TVaiCepSucess.Setlocalidades(const Value: string);
begin
  flocalidade := Value;
end;

procedure TVaiCepSucess.Setlogradouro(const Value: string);
begin
  flogradouro := Value;
end;

procedure TVaiCepSucess.Setsiafi(const Value: string);
begin
  fsiafi := Value;
end;

procedure TVaiCepSucess.Setuf(const Value: string);
begin
  fuf := Value;
end;

end.
