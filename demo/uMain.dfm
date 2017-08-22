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
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 713
    Height = 629
    Align = alLeft
    Lines.Strings = (
      '<?xml version="1.0" standalone="no"?>'
      '<S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/">'
      '  <S:Header>'
      
        '    <wss:Security xmlns:wss="http://schemas.xmlsoap.org/ws/2002/' +
        '12/secext">'
      '      <wss:UsernameToken>'
      '        <wss:Username>207250618/1</wss:Username>'
      '        <wss:Nonce></wss:Nonce>'
      '        <wss:Password>123456789</wss:Password>'
      '        <wss:Created></wss:Created>'
      '      </wss:UsernameToken>'
      '    </wss:Security>'
      '  </S:Header>'
      '  <S:Body>'
      
        '    <ns2:envioDocumentoTransporteRequestElem xmlns:ns2="https://' +
        'servicos.portaldasfinancas.gov.pt/sgdtws/documentosTransporte/">'
      '      <TaxRegistrationNumber>207250618</TaxRegistrationNumber>'
      '      <CompanyName>Coiso e Tal Lda.</CompanyName>'
      '      <CompanyAddress>'
      '        <Addressdetail>L'#225' Mesmo N 6 Lj 3</Addressdetail>'
      '        <City>Cascos de Rolha</City>'
      '        <PostalCode>8050-000</PostalCode>'
      '        <Country>PT</Country>'
      '      </CompanyAddress>'
      '      <DocumentNumber>GT 001/528</DocumentNumber>'
      '      <MovementStatus>N</MovementStatus>'
      '      <MovementDate>2017-08-16</MovementDate>'
      '      <MovementType>GT</MovementType>'
      '      <CustomerTaxID>999999990</CustomerTaxID>'
      '      <CustomerAddress>'
      '        <Addressdetail>Curral de Moinas</Addressdetail>'
      '        <City>Portada</City>'
      '        <PostalCode>8888-000</PostalCode>'
      '        <Country>PT</Country>'
      '      </CustomerAddress>'
      '      <CustomerName>Ti Manel</CustomerName>'
      '      <AddressTo>'
      '        <Addressdetail>Vale da Moita</Addressdetail>'
      '        <City>Portel</City>'
      '        <PostalCode>8884-144</PostalCode>'
      '        <Country>PT</Country>'
      '      </AddressTo>'
      '      <AddressFrom>'
      '        <Addressdetail>Vilar Paraiso</Addressdetail>'
      '        <City>Terra Dele</City>'
      '        <PostalCode>9999-144</PostalCode>'
      '        <Country>PT</Country>'
      '      </AddressFrom>'
      '      <MovementStartTime>2017-08-18T14:50:00</MovementStartTime>'
      '      <VehicleID>AA-00-00</VehicleID>'
      '      <Line>'
      '        <ProductDescription>Papel A4</ProductDescription>'
      '        <Quantity>5</Quantity>'
      '        <UnitOfMeasure>Un</UnitOfMeasure>'
      '        <UnitPrice>3.00</UnitPrice>'
      '      </Line>'
      '    </ns2:envioDocumentoTransporteRequestElem>'
      '  </S:Body>'
      '</S:Envelope>')
    TabOrder = 0
  end
  object bSetupProductionWS: TButton
    Left = 736
    Top = 56
    Width = 201
    Height = 42
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Inicializar Webservice de Produ'#231#227'o'
    TabOrder = 1
    OnClick = bSetupProductionWSClick
  end
  object bSetupTestingWS: TButton
    Left = 736
    Top = 8
    Width = 201
    Height = 42
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Inicializar Webservice de Testes'
    TabOrder = 2
    OnClick = bSetupTestingWSClick
  end
  object Memo2: TMemo
    Left = 719
    Top = 151
    Width = 236
    Height = 478
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 3
  end
  object bSendDoc: TButton
    Left = 736
    Top = 103
    Width = 201
    Height = 42
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Enviar documento'
    Enabled = False
    TabOrder = 4
    OnClick = bSendDocClick
  end
end
