object frmCadastro: TfrmCadastro
  Left = 0
  Top = 0
  Caption = 'Cadastro de Clientes'
  ClientHeight = 507
  ClientWidth = 582
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pgcCadastro: TPageControl
    Left = 0
    Top = 0
    Width = 582
    Height = 507
    ActivePage = TabEmail
    Align = alClient
    TabOrder = 0
    object TabCliente: TTabSheet
      Caption = 'Cliente'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 709
      ExplicitHeight = 457
      object lblNome: TLabel
        Left = 64
        Top = 36
        Width = 27
        Height = 13
        Caption = 'Nome'
      end
      object lblIdentidade: TLabel
        Left = 64
        Top = 63
        Width = 52
        Height = 13
        Caption = 'Identidade'
      end
      object lblCPF: TLabel
        Left = 64
        Top = 90
        Width = 19
        Height = 13
        Caption = 'CPF'
      end
      object lblTelefone: TLabel
        Left = 64
        Top = 117
        Width = 42
        Height = 13
        Caption = 'Telefone'
      end
      object lblEmail: TLabel
        Left = 64
        Top = 144
        Width = 24
        Height = 13
        Caption = 'Email'
      end
      object edtNome: TEdit
        Left = 142
        Top = 33
        Width = 342
        Height = 21
        TabOrder = 0
      end
      object edtIdentidade: TEdit
        Left = 142
        Top = 60
        Width = 166
        Height = 21
        TabOrder = 1
      end
      object edtCPF: TMaskEdit
        Left = 141
        Top = 87
        Width = 115
        Height = 21
        EditMask = '000\.000\.000\-00;0;_'
        MaxLength = 14
        TabOrder = 2
        Text = ''
      end
      object edttelefone: TMaskEdit
        Left = 142
        Top = 114
        Width = 119
        Height = 21
        EditMask = '!\(99\) 0000-00009;0;_'
        MaxLength = 15
        TabOrder = 3
        Text = ''
      end
      object edtEmail: TEdit
        Left = 141
        Top = 141
        Width = 345
        Height = 21
        TabOrder = 4
      end
      object gpbEndereco: TGroupBox
        Left = 55
        Top = 170
        Width = 474
        Height = 264
        Caption = 'Endere'#231'o'
        TabOrder = 5
        object lblCep: TLabel
          Left = 9
          Top = 34
          Width = 19
          Height = 13
          Caption = 'Cep'
        end
        object lblLogradouro: TLabel
          Left = 9
          Top = 61
          Width = 55
          Height = 13
          Caption = 'Logradouro'
        end
        object lblNumero: TLabel
          Left = 9
          Top = 88
          Width = 37
          Height = 13
          Caption = 'N'#250'mero'
        end
        object lblComplemento: TLabel
          Left = 9
          Top = 115
          Width = 65
          Height = 13
          Caption = 'Complemento'
        end
        object lblBairro: TLabel
          Left = 8
          Top = 142
          Width = 28
          Height = 13
          Caption = 'Bairro'
        end
        object lblCidade: TLabel
          Left = 9
          Top = 169
          Width = 33
          Height = 13
          Caption = 'Cidade'
        end
        object lblEstado: TLabel
          Left = 9
          Top = 197
          Width = 33
          Height = 13
          Caption = 'Estado'
        end
        object lblPais: TLabel
          Left = 8
          Top = 223
          Width = 19
          Height = 13
          Caption = 'Pais'
        end
        object edtCep: TMaskEdit
          Left = 86
          Top = 31
          Width = 100
          Height = 21
          EditMask = '00000\-000;0;_'
          MaxLength = 9
          TabOrder = 0
          Text = ''
          OnExit = edtCepExit
        end
        object edtLogradouro: TEdit
          Left = 86
          Top = 58
          Width = 345
          Height = 21
          TabOrder = 1
        end
        object edtNumero: TEdit
          Left = 86
          Top = 85
          Width = 121
          Height = 21
          TabOrder = 2
        end
        object edtComplemento: TEdit
          Left = 86
          Top = 112
          Width = 169
          Height = 21
          TabOrder = 3
        end
        object edtBairro: TEdit
          Left = 86
          Top = 139
          Width = 227
          Height = 21
          TabOrder = 4
        end
        object edtCidade: TEdit
          Left = 86
          Top = 166
          Width = 227
          Height = 21
          TabOrder = 5
        end
        object edtEstado: TEdit
          Left = 86
          Top = 193
          Width = 35
          Height = 21
          TabOrder = 6
        end
        object edtPais: TEdit
          Left = 86
          Top = 220
          Width = 227
          Height = 21
          TabOrder = 7
        end
      end
      object btnEnviarEmail: TButton
        Left = 166
        Top = 440
        Width = 75
        Height = 25
        Caption = 'Enviar Email'
        TabOrder = 6
        OnClick = btnEnviarEmailClick
      end
    end
    object TabEmail: TTabSheet
      Caption = 'Email'
      ImageIndex = 1
      object lblHost: TLabel
        Left = 41
        Top = 90
        Width = 22
        Height = 13
        Caption = 'Host'
      end
      object lblUserName: TLabel
        Left = 41
        Top = 117
        Width = 36
        Height = 13
        Caption = 'Usu'#225'rio'
      end
      object lblPassword: TLabel
        Left = 41
        Top = 144
        Width = 30
        Height = 13
        Caption = 'Senha'
      end
      object lblPorta: TLabel
        Left = 257
        Top = 90
        Width = 26
        Height = 13
        Caption = 'Porta'
      end
      object lblPara: TLabel
        Left = 40
        Top = 198
        Width = 22
        Height = 13
        Caption = 'Para'
      end
      object lblAssunto: TLabel
        Left = 41
        Top = 225
        Width = 39
        Height = 13
        Caption = 'Assunto'
      end
      object Label9: TLabel
        Left = 64
        Top = 25
        Width = 330
        Height = 26
        Caption = 
          'Obs.: Caso o email de origem seja do Gmail, necessario habilitar' +
          ' o "Acesso a pp menos seguro", para que o envio ocorra corretame' +
          'nte.'
        WordWrap = True
      end
      object edtHost: TMaskEdit
        Left = 118
        Top = 87
        Width = 100
        Height = 21
        TabOrder = 0
        Text = 'smtp.gmail.com'
        OnExit = edtCepExit
      end
      object edtUserName: TEdit
        Left = 118
        Top = 114
        Width = 251
        Height = 21
        TabOrder = 2
        Text = 'seuemail@gmail.com'
      end
      object edtPassword: TEdit
        Left = 118
        Top = 141
        Width = 121
        Height = 21
        PasswordChar = '*'
        TabOrder = 3
        Text = '1234'
      end
      object edtPorta: TEdit
        Left = 334
        Top = 87
        Width = 35
        Height = 21
        TabOrder = 1
        Text = '465'
      end
      object edtPara: TEdit
        Left = 118
        Top = 195
        Width = 227
        Height = 21
        TabOrder = 4
        Text = 'destinatario@gmail.com'
      end
      object edtAssunto: TEdit
        Left = 118
        Top = 222
        Width = 227
        Height = 21
        TabOrder = 5
        Text = 'Teste cadastro Cliente'
      end
    end
  end
end
