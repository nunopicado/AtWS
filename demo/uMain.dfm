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
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter: TSplitter
    Left = 713
    Top = 0
    Height = 629
    ExplicitLeft = 568
    ExplicitTop = 296
    ExplicitHeight = 100
  end
  object memoRequest: TMemo
    Left = 0
    Top = 0
    Width = 713
    Height = 629
    Align = alLeft
    TabOrder = 0
  end
  object pnlTools: TPanel
    Left = 716
    Top = 0
    Width = 239
    Height = 629
    Align = alClient
    Caption = 'pnlTools'
    ShowCaption = False
    TabOrder = 1
    DesignSize = (
      239
      629)
    object bSendDoc: TButton
      Left = 3
      Top = 147
      Width = 236
      Height = 42
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Enviar documento'
      Enabled = False
      TabOrder = 0
      WordWrap = True
      OnClick = bSendDocClick
    end
    object bSetupProductionDTWS: TButton
      Left = 125
      Top = 8
      Width = 114
      Height = 42
      Caption = 'Inicializar Webservice de Produ'#231#227'o DT'
      TabOrder = 1
      WordWrap = True
      OnClick = bSetupProductionDTWSClick
    end
    object bSetupProductionFTWS: TButton
      Left = 125
      Top = 55
      Width = 114
      Height = 42
      Anchors = [akTop, akRight]
      Caption = 'Inicializar Webservice de Produ'#231#227'o FT'
      TabOrder = 2
      WordWrap = True
      OnClick = bSetupProductionFTWSClick
    end
    object bSetupTestingDTWS: TButton
      Left = 3
      Top = 8
      Width = 114
      Height = 42
      Caption = 'Inicializar Webservice de Testes DT'
      TabOrder = 3
      WordWrap = True
      OnClick = bSetupTestingDTWSClick
    end
    object bSetupTestingFTWS: TButton
      Left = 3
      Top = 55
      Width = 114
      Height = 42
      Anchors = [akTop, akRight]
      Caption = 'Inicializar Webservice de Testes FT'
      TabOrder = 4
      WordWrap = True
      OnClick = bSetupTestingFTWSClick
    end
    object memoResponse: TMemo
      Left = 3
      Top = 195
      Width = 236
      Height = 434
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 5
    end
    object bSetupTestingSEWS: TButton
      Left = 3
      Top = 102
      Width = 114
      Height = 42
      Anchors = [akTop, akRight]
      Caption = 'Inicializar Webservice de Testes SE'
      TabOrder = 6
      WordWrap = True
      OnClick = bSetupTestingSEWSClick
    end
    object bSetupProductionSEWS: TButton
      Left = 125
      Top = 102
      Width = 114
      Height = 42
      Anchors = [akTop, akRight]
      Caption = 'Inicializar Webservice de Produ'#231#227'o SE'
      TabOrder = 7
      WordWrap = True
      OnClick = bSetupProductionSEWSClick
    end
  end
end
