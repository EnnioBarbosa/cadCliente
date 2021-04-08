unit uCliente;

interface

{$M+}

uses
  System.SysUtils, System.Classes;

type

 TCliente = class(TPersistent)
  private
    flogradouro: string;
    fbairro: string;
    femail: string;
    fcpf: string;
    fcep: string;
    fnumero: string;
    fidentidade: string;
    fcomplemento: string;
    fnome: string;
    fcidade: string;
    fpais: string;
    festado: string;
    ftelefone: string;
    procedure Setbairro(const Value: string);
    procedure Setcep(const Value: string);
    procedure Setcidade(const Value: string);
    procedure Setcomplemento(const Value: string);
    procedure Setcpf(const Value: string);
    procedure Setemail(const Value: string);
    procedure Setestado(const Value: string);
    procedure Setidentidade(const Value: string);
    procedure Setlogradouro(const Value: string);
    procedure Setnome(const Value: string);
    procedure Setnumero(const Value: string);
    procedure Setpais(const Value: string);
    procedure Settelefone(const Value: string);
 public
   function JsonString: string;
   function XMLString: string;
 published
   property nome : string read fnome write Setnome;
   property identidade : string read fidentidade write Setidentidade;
   property cpf : string read fcpf write Setcpf;
   property telefone : string read ftelefone write Settelefone;
   property email : string read femail write Setemail;
   property cep : string read fcep write Setcep;
   property logradouro : string read flogradouro write Setlogradouro;
   property numero : string read fnumero write Setnumero;
   property complemento : string read fcomplemento write Setcomplemento;
   property bairro : string read fbairro write Setbairro;
   property cidade : string read fcidade write Setcidade;
   property estado : string read festado write Setestado;
   property pais : string read fpais write Setpais;
 end;

implementation

uses REST.Json, ActiveX, XMLIntf, XMLDoc, TypInfo;

{ TCliente }

function TCliente.JsonString: string;
begin
  result := TJson.ObjectToJsonString(Self);
end;

procedure TCliente.Setbairro(const Value: string);
begin
  fbairro := Value;
end;

procedure TCliente.Setcep(const Value: string);
begin
  fcep := Value;
end;

procedure TCliente.Setcidade(const Value: string);
begin
  fcidade := Value;
end;

procedure TCliente.Setcomplemento(const Value: string);
begin
  fcomplemento := Value;
end;

procedure TCliente.Setcpf(const Value: string);
begin
  fcpf := Value;
end;

procedure TCliente.Setemail(const Value: string);
begin
  femail := Value;
end;

procedure TCliente.Setestado(const Value: string);
begin
  festado := Value;
end;

procedure TCliente.Setidentidade(const Value: string);
begin
  fidentidade := Value;
end;

procedure TCliente.Setlogradouro(const Value: string);
begin
  flogradouro := Value;
end;

procedure TCliente.Setnome(const Value: string);
begin
  fnome := Value;
end;

procedure TCliente.Setnumero(const Value: string);
begin
  fnumero := Value;
end;

procedure TCliente.Setpais(const Value: string);
begin
  fpais := Value;
end;

procedure TCliente.Settelefone(const Value: string);
begin
  ftelefone := Value;
end;

function TCliente.XMLString: string;
var
  iXML : IXMLDocument;
  iRootNode, iNode: IXMLNode;
  Count, i: Integer;
  List: PPropList;
  Info: PPropInfo;
begin
  iXML := NewXMLDocument;
  iXML.Options := [doNodeAutoIndent];
  iRootNode := iXML.AddChild(self.ClassName);

  Count := GetPropList(self.ClassInfo, tkProperties, nil);
  GetMem(List, Count * SizeOf(Pointer));
  try
    Count := GetPropList(Self.ClassInfo, tkProperties, List, False);
    for i := 0 to Count - 1 do
    begin
      Info := List^[i];

      iNode := iRootNode.AddChild(Info^.Name);
      iNode.Text := GetPropValue(self, Info^.Name, True);
    end;
  finally
    FreeMem(List);
  end;
  result := iXML.XML.Text;
end;

end.
