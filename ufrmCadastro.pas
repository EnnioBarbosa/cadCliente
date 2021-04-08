unit ufrmCadastro;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, uViaCep,
  Vcl.ComCtrls;

type
  TfrmCadastro = class(TForm)
    pgcCadastro: TPageControl;
    TabCliente: TTabSheet;
    TabEmail: TTabSheet;
    lblNome: TLabel;
    lblIdentidade: TLabel;
    lblCPF: TLabel;
    lblTelefone: TLabel;
    lblEmail: TLabel;
    edtNome: TEdit;
    edtIdentidade: TEdit;
    edtCPF: TMaskEdit;
    edttelefone: TMaskEdit;
    edtEmail: TEdit;
    gpbEndereco: TGroupBox;
    lblCep: TLabel;
    lblLogradouro: TLabel;
    lblNumero: TLabel;
    lblComplemento: TLabel;
    lblBairro: TLabel;
    lblCidade: TLabel;
    lblEstado: TLabel;
    lblPais: TLabel;
    edtCep: TMaskEdit;
    edtLogradouro: TEdit;
    edtNumero: TEdit;
    edtComplemento: TEdit;
    edtBairro: TEdit;
    edtCidade: TEdit;
    edtEstado: TEdit;
    edtPais: TEdit;
    btnEnviarEmail: TButton;
    lblHost: TLabel;
    edtHost: TMaskEdit;
    lblUserName: TLabel;
    edtUserName: TEdit;
    lblPassword: TLabel;
    edtPassword: TEdit;
    lblPorta: TLabel;
    edtPorta: TEdit;
    lblPara: TLabel;
    edtPara: TEdit;
    lblAssunto: TLabel;
    edtAssunto: TEdit;
    Label9: TLabel;
    procedure edtCepExit(Sender: TObject);
    procedure btnEnviarEmailClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure PreencheCamposCep(pDadosCep: TVaiCepSucess);
    function VerificaPreenchimento: boolean;
    function ValidaParamEmail: Boolean;
    function GeraXML: string;
    function GeraArquioXML(const pXML: String): string;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCadastro: TfrmCadastro;

implementation

uses uEMail, uCliente;

{$R *.dfm}

procedure TfrmCadastro.btnEnviarEmailClick(Sender: TObject);
var aXML: String;
    aArqName: String;
begin
  if not VerificaPreenchimento then
    Exit;

  if not ValidaParamEmail then
    Exit;

  // Gera o XML a partir dos dados informados;
  aXML := GeraXML;

  aArqName := GeraArquioXML(aXML);


  SendEmailSMTP(edtHost.Text,
                edtUserName.Text,
                edtPassword.Text,
                EdtPara.Text,
                edtAssunto.Text,
                aXML,
                aArqName,
                StrToInt(edtPorta.Text))
end;

procedure TfrmCadastro.edtCepExit(Sender: TObject);
var DadosCep: TVaiCepSucess;
    CepEncontrado: Boolean;
begin
  DadosCep := TVaiCepSucess.Create;
  try
    CepEncontrado := TViaCep.PesquisaCep(edtCep.Text, DadosCep);
    if CepEncontrado then
      PreencheCamposCep(DadosCep)
    else
    begin
      ShowMessage('Cep não encontrado, informe um Cep Válido!');
//      Edtcep.SetFocus;
    end;
  finally
    FreeAndNil(DadosCep);
  end;
end;

procedure TfrmCadastro.FormShow(Sender: TObject);
begin
//  {$IFDEF DEBUG}
//  edtnome.text := 'Ennio Barbosa';
//  edtIdentidade.text := 'TS 887787-09';
//  edtCPF.text := '11111111111';
//  edtTelefone.text := '31991874880';
//  edtemail.text := 'enniobarbosa@gamil.com';
//  edtcep.text := '33400000';
//  edtLogradouro.Text := 'Av Orion';
//  edtNumero.Text := '648';
//  edtComplemento.Text := 'Continente Americano';
//  edtBairro.Text := 'Planeta Terra';
//  edtCidade.Text := 'Via Lactea';
//  edtEstado.Text := 'VL';
//  edtpais.Text := 'Universo';
//  {$ENDIF}
end;

function TfrmCadastro.GeraArquioXML(const pXML: String): string;
var str : TStrings;
begin
  result := ExtractFilePath(ParamStr(0))+
                            'Cliente_' +
                            FormatDateTime('yyyymmddHHmmss', now)+'.xml';
  str := tStringList.Create;
  try
    str.Text := pXML;
    str.SaveToFile(result);
  finally
    FreeAndNil(str);
  end;
end;

function TfrmCadastro.GeraXML: String;
var iCliente: TCliente;
begin
  iCliente := TCliente.Create;
  try
    iCliente.nome := edtnome.Text;
    iCliente.Identidade := edtIdentidade.Text;
    iCliente.cpf := edtCPF.Text;
    iCliente.telefone := edtTelefone.Text;
    iCliente.email := edtemail.Text;
    iCliente.cep := edtcep.Text;
    iCliente.logradouro := edtLogradouro.Text;
    iCliente.numero := edtNumero.Text;
    iCliente.complemento := edtComplemento.Text;
    iCliente.bairro := edtBairro.Text;
    iCliente.cidade := edtCidade.Text;
    iCliente.estado := edtEstado.Text;
    iCliente.pais := edtpais.Text;

    result := iCliente.XMLString;

  finally
    FreeAndNil(iCliente);
  end;
end;

procedure TfrmCadastro.PreencheCamposCep(pDadosCep: TVaiCepSucess);
begin
  edtLogradouro.Text := pDadosCep.logradouro;
  edtComplemento.Text := pDadosCep.complemento;
  edtBairro.Text := pDadosCep.bairro;
  edtCidade.Text := pDadosCep.localidade;
  edtEstado.Text := pDadosCep.uf;

  edtLogradouro.ReadOnly := Not pDadosCep.logradouro.IsEmpty;
  edtComplemento.ReadOnly := Not pDadosCep.complemento.IsEmpty;
  edtBairro.ReadOnly := Not pDadosCep.bairro.IsEmpty;
  edtCidade.ReadOnly := Not pDadosCep.localidade.IsEmpty;
  edtEstado.ReadOnly := Not pDadosCep.uf.IsEmpty;
end;

function TfrmCadastro.ValidaParamEmail: Boolean;
begin
  Result := true;
  if (edtUsername.Text = 'seuemail@gmail.com') or (edtUsername.Text = '') then
  begin
    ShowMessage('Informe um email Válido, no campo Usuário!');
    Result := False;
    Exit;
  end;
  if (edtPassWord.Text = '1234') or (edtUsername.Text = '') then
  begin
    ShowMessage('Informe uma senha válida, no campo Senha!');
    Result := False;
    Exit;
  end;
end;

function TfrmCadastro.VerificaPreenchimento: Boolean;
var i: Integer;
    Campo: String;
begin
  Result := true;
  for i := 0 to Self.ComponentCount-1 do
  begin
    if Self.Components[i] Is TCustomEdit then
      if TCustomEdit(Self.Components[i]).Text = EmptyStr then
      begin
        Campo := TCustomEdit(Self.Components[i]).Name;
        ShowMessage('Campo: ' + Campo.Substring(3) + ' não informado!');
        TCustomEdit(Self.Components[i]).SetFocus;
        Result := False;
        Exit;
      end;
  end;

end;

end.
