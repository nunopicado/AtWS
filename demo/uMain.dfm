object fMain: TfMain
  Left = 0
  Top = 0
  Caption = 'AtWS Demo'
  ClientHeight = 629
  ClientWidth = 955
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    955
    629)
  PixelsPerInch = 96
  TextHeight = 13
  object memoRequest: TMemo
    Left = 0
    Top = 0
    Width = 713
    Height = 629
    Align = alLeft
    TabOrder = 0
  end
  object bSetupProductionDTWS: TButton
    Left = 719
    Top = 55
    Width = 114
    Height = 42
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Inicializar Webservice de Produ'#231#227'o DT'
    TabOrder = 1
    WordWrap = True
    OnClick = bSetupProductionDTWSClick
  end
  object bSetupTestingDTWS: TButton
    Left = 719
    Top = 8
    Width = 114
    Height = 42
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Inicializar Webservice de Testes DT'
    TabOrder = 2
    WordWrap = True
    OnClick = bSetupTestingDTWSClick
  end
  object memoResponse: TMemo
    Left = 719
    Top = 151
    Width = 236
    Height = 478
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 3
  end
  object bSendDoc: TButton
    Left = 719
    Top = 103
    Width = 230
    Height = 42
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Enviar documento'
    Enabled = False
    TabOrder = 4
    WordWrap = True
    OnClick = bSendDocClick
  end
  object bSetupTestingFTWS: TButton
    Left = 833
    Top = 8
    Width = 114
    Height = 42
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Inicializar Webservice de Testes FT'
    TabOrder = 5
    WordWrap = True
    OnClick = bSetupTestingFTWSClick
  end
  object bSetupProductionFTWS: TButton
    Left = 835
    Top = 55
    Width = 114
    Height = 42
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Inicializar Webservice de Produ'#231#227'o FT'
    TabOrder = 6
    WordWrap = True
    OnClick = bSetupProductionFTWSClick
  end
end
