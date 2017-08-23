(******************************************************************************)
(** Suite         : AtWS                                                     **)
(** Object        : TfMain                                                   **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(******************************************************************************)
(** Dependencies  : AtWS                                                     **)
(******************************************************************************)
(** Description   : Demo project for AtWS.dll                                **)
(******************************************************************************)
(** Licence       : MIT (https://opensource.org/licenses/MIT)                **)
(** Contributions : You can create pull request for all your desired         **)
(**                 contributions as long as they comply with the guidelines **)
(**                 you can find in the readme.md file in the main directory **)
(**                 of the Reusable Objects repository                       **)
(** Disclaimer    : The licence agreement applies to the code in this unit   **)
(**                 and not to any of its dependencies, which have their own **)
(**                 licence agreement and to which you must comply in their  **)
(**	                terms                                                    **)
(******************************************************************************)

unit uMain;

interface

uses
    Classes
  , Controls
  , Forms
  , StdCtrls
  , AtWSvcIntf
  ;

type
  TfMain = class(TForm)
    memoRequest: TMemo;
    bSetupProductionDTWS: TButton;
    bSetupTestingDTWS: TButton;
    memoResponse: TMemo;
    bSendDoc: TButton;
    bSetupTestingFTWS: TButton;
    bSetupProductionFTWS: TButton;
    procedure bSetupProductionDTWSClick(Sender: TObject);
    procedure bSetupTestingDTWSClick(Sender: TObject);
    procedure bSendDocClick(Sender: TObject);
    procedure bSetupTestingFTWSClick(Sender: TObject);
    procedure bSetupProductionFTWSClick(Sender: TObject);
  private
    FAtWS: IAtWSvc;
  public
    { Public declarations }
  end;

var
  fMain: TfMain;

function ATWebService(const SoapURL, SoapAction, PubKeyFile, PFXFile, PFXPass: WideString): IAtWSvc; stdcall; external 'AtWS.dll';

implementation

uses
    Dialogs
  , XMLDoc
  , SysUtils
  ;

const
  SampleFTXML = '<?xml version="1.0" standalone="no"?>'+
                '  <S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/">'+
                '    <S:Header>'+
                '      <wss:Security xmlns:wss="http://schemas.xmlsoap.org/ws/2002/12/secext">'+
                '        <wss:UsernameToken>'+
                '          <wss:Username>555555550/1</wss:Username>'+
                '          <wss:Password>123456789</wss:Password>'+
                '          <wss:Nonce></wss:Nonce>'+
                '          <wss:Created></wss:Created>'+
                '        </wss:UsernameToken>'+
                '      </wss:Security>'+
                '    </S:Header>'+
                '    <S:Body>'+
                '      <ns2:RegisterInvoiceElem xmlns:ns2="http://servicos.portaldasfinancas.gov.pt/faturas/">'+
                '        <TaxRegistrationNumber>555555550</TaxRegistrationNumber>'+
                '        <ns2:InvoiceNo>FT 1/1</ns2:InvoiceNo>'+
                '        <ns2:InvoiceDate>2017-08-23</ns2:InvoiceDate>'+
                '        <ns2:InvoiceType>FT</ns2:InvoiceType>'+
                '        <ns2:InvoiceStatus>N</ns2:InvoiceStatus>'+
                '        <CustomerTaxID>111111111</CustomerTaxID>'+
                '        <Line>'+
                '          <ns2:DebitAmount>100</ns2:DebitAmount>'+
                '          <ns2:Tax>'+
                '            <ns2:TaxType>IVA</ns2:TaxType>'+
                '            <ns2:TaxCountryRegion>PT</ns2:TaxCountryRegion>'+
                '            <ns2:TaxPercentage>23</ns2:TaxPercentage>'+
                '          </ns2:Tax>'+
                '        </Line>'+
                '        <DocumentTotals>'+
                '          <ns2:TaxPayable>23</ns2:TaxPayable>'+
                '          <ns2:NetTotal>100</ns2:NetTotal>'+
                '          <ns2:GrossTotal>123</ns2:GrossTotal>'+
                '        </DocumentTotals>'+
                '      </ns2:RegisterInvoiceElem>'+
                '    </S:Body>'+
                '  </S:Envelope>';

  SampleDTXML = '<?xml version="1.0" standalone="no"?>'+
                '  <S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/">'+
                '    <S:Header>'+
                '      <wss:Security xmlns:wss="http://schemas.xmlsoap.org/ws/2002/12/secext">'+
                '        <wss:UsernameToken>'+
                '          <wss:Username>207250618/1</wss:Username>'+
                '          <wss:Nonce></wss:Nonce>'+
                '          <wss:Password>123456789</wss:Password>'+
                '          <wss:Created></wss:Created>'+
                '        </wss:UsernameToken>'+
                '      </wss:Security>'+
                '    </S:Header>'+
                '    <S:Body>'+
                '      <ns2:envioDocumentoTransporteRequestElem xmlns:ns2="https://servicos.portaldasfinancas.gov.pt/sgdtws/documentosTransporte/">'+
                '        <TaxRegistrationNumber>207250618</TaxRegistrationNumber>'+
                '        <CompanyName>Coiso e Tal Lda.</CompanyName>'+
                '        <CompanyAddress>'+
                '          <Addressdetail>Lá Mesmo N 6 Lj 3</Addressdetail>'+
                '          <City>Cascos de Rolha</City>'+
                '          <PostalCode>8050-000</PostalCode>'+
                '          <Country>PT</Country>'+
                '        </CompanyAddress>'+
                '        <DocumentNumber>GT 001/528</DocumentNumber>'+
                '        <MovementStatus>N</MovementStatus>'+
                '        <MovementDate>2017-08-16</MovementDate>'+
                '        <MovementType>GT</MovementType>'+
                '        <CustomerTaxID>999999990</CustomerTaxID>'+
                '        <CustomerAddress>'+
                '          <Addressdetail>Curral de Moinas</Addressdetail>'+
                '          <City>Portada</City>'+
                '          <PostalCode>8888-000</PostalCode>'+
                '          <Country>PT</Country>'+
                '        </CustomerAddress>'+
                '        <CustomerName>Ti Manel</CustomerName>'+
                '        <AddressTo>'+
                '          <Addressdetail>Vale da Moita</Addressdetail>'+
                '          <City>Portel</City>'+
                '          <PostalCode>8884-144</PostalCode>'+
                '          <Country>PT</Country>'+
                '        </AddressTo>'+
                '        <AddressFrom>'+
                '          <Addressdetail>Vilar Paraiso</Addressdetail>'+
                '          <City>Terra Dele</City>'+
                '          <PostalCode>9999-144</PostalCode>'+
                '          <Country>PT</Country>'+
                '        </AddressFrom>'+
                '        <MovementStartTime>2017-08-18T14:50:00</MovementStartTime>'+
                '        <VehicleID>AA-00-00</VehicleID>'+
                '        <Line>'+
                '          <ProductDescription>Papel A4</ProductDescription>'+
                '          <Quantity>5</Quantity>'+
                '          <UnitOfMeasure>Un</UnitOfMeasure>'+
                '          <UnitPrice>3.00</UnitPrice>'+
                '        </Line>'+
                '      </ns2:envioDocumentoTransporteRequestElem>'+
                '    </S:Body>'+
                '  </S:Envelope>';

{$R *.dfm}

procedure TfMain.bSetupTestingDTWSClick(Sender: TObject);
begin
  FAtWS := ATWebService(
    'https://servicos.portaldasfinancas.gov.pt:701/sgdtws/documentosTransporte',
    'https://servicos.portaldasfinancas.gov.pt/sgdtws/documentosTransporte/',
    'ChavePublicaAT.pem',
    'TESTEWebServices.pfx',
    'TESTEwebservice'
  );
  bSendDoc.Caption := 'Enviar documento DT de Teste';
  bSendDoc.Enabled := True;
  memoRequest.Text := FormatXMLData(SampleDTXML);
end;

procedure TfMain.bSetupTestingFTWSClick(Sender: TObject);
begin
  FAtWS := ATWebService(
    'https://servicos.portaldasfinancas.gov.pt:700/fews/faturas',
    'http://servicos.portaldasfinancas.gov.pt/faturas/RegisterInvoice',
    'ChavePublicaAT.pem',
    'TESTEWebServices.pfx',
    'TESTEwebservice'
  );
  bSendDoc.Caption := 'Enviar documento FT de Teste';
  bSendDoc.Enabled := True;
  memoRequest.Text := FormatXMLData(SampleFTXML);
end;

procedure TfMain.bSetupProductionFTWSClick(Sender: TObject);
begin
  FAtWS := ATWebService(
    'https://servicos.portaldasfinancas.gov.pt:400/fews/faturas',
    'http://servicos.portaldasfinancas.gov.pt/faturas/RegisterInvoice',
    'ChavePublicaAT.pem',
    '555555550.pfx',
    'XPTO'
  );
  bSendDoc.Caption := 'Enviar documento FT de Produção';
  bSendDoc.Enabled := True;
  memoRequest.Text := FormatXMLData(SampleFTXML);
end;

procedure TfMain.bSendDocClick(Sender: TObject);
begin
  if not Assigned(FAtWS)
    then raise Exception.Create('Webservice not initialized.');
  memoResponse.Text := FormatXMLData(
    FAtWS.Send(
      memoRequest.Text
    )
  );
end;

procedure TfMain.bSetupProductionDTWSClick(Sender: TObject);
begin
  FAtWS := ATWebService(
    'https://servicos.portaldasfinancas.gov.pt:401/sgdtws/documentosTransporte',
    'https://servicos.portaldasfinancas.gov.pt/sgdtws/documentosTransporte/',
    'ChavePublicaAT.pem',
    '555555550.pfx',
    'XPTO'
  );
  bSendDoc.Caption := 'Enviar documento DT de Produção';
  bSendDoc.Enabled := True;
  memoRequest.Text := FormatXMLData(SampleDTXML);
end;

end.
