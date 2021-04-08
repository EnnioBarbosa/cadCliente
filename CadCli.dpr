program CadCli;

uses
  Vcl.Forms,
  ufrmCadastro in 'ufrmCadastro.pas' {frmCadastro},
  uViaCep in 'uViaCep.pas',
  uEmail in 'uEmail.pas',
  uCliente in 'uCliente.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmCadastro, frmCadastro);
  Application.Run;
end.
