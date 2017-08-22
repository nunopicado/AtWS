object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
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
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 713
    Height = 629
    Align = alLeft
    Anchors = [akLeft, akTop, akRight, akBottom]
    Lines.Strings = (
      '<?xml version="1.0" standalone="no"?>'
      '<S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/">'
      '  <S:Header>'
      
        '    <wss:Security xmlns:wss="http://schemas.xmlsoap.org/ws/2002/' +
        '12/secext">'
      '      <wss:UsernameToken>'
      '        <wss:Username>555555550/1</wss:Username>'
      '        <wss:Nonce></wss:Nonce>'
      '        <wss:Password>123456789</wss:Password>'
      '        <wss:Created></wss:Created>'
      '      </wss:UsernameToken>'
      '    </wss:Security>'
      '  </S:Header>'
      '  <S:Body>'
      
        '    <ns2:envioDocumentoTransporteRequestElem xmlns:ns2="https://' +
        'servicos.portaldasfinancas.gov.pt/sgdtws/documentosTransporte/">'
      '      <TaxRegistrationNumber>555555550</TaxRegistrationNumber>'
      '      <CompanyName>Coiso e Tal Lda.</CompanyName>'
      '      <CompanyAddress>'
      '        <Addressdetail>L'#225' Mesmo N 6 Lj 3</Addressdetail>'
      '        <City>Cascos de Rolha</City>'
      '        <PostalCode>8050-000</PostalCode>'
      '        <Country>PT</Country>'
      '      </CompanyAddress>'
      '      <DocumentNumber>GT 001/528</DocumentNumber>'
      '      <MovementStatus>N</MovementStatus>'
      '      <MovementDate>2013-06-07</MovementDate>'
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
      '      <MovementStartTime>2013-09-28T14:50:00</MovementStartTime>'
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
  object Button2: TButton
    Left = 736
    Top = 88
    Width = 201
    Height = 57
    Caption = 'Produ'#231#227'o'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button1: TButton
    Left = 736
    Top = 15
    Width = 201
    Height = 57
    Caption = 'Testes'
    TabOrder = 2
    OnClick = Button1Click
  end
end
