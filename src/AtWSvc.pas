unit AtWSvc;

interface

uses
    SOAPHTTPTrans
  , AtWSvcIntf
  ;

type


  TAtWSvc = class(TInterfacedObject, IAtWSvc)
  private const
    cATUrl = 'https://faturas.portaldasfinancas.gov.pt/';
    // ChavePublicaAT.pem, convertido do ChavePublicAT.cer via OpenSSL
    cATPublicKey = '-----BEGIN PUBLIC KEY-----'#10 +
      'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAoQi+XDM9OJ+Kr+Blaxn3'#10 +
      'MFBE7UMYL7bfPGCxS0JDIbYlfQp65mYfzRcIhwysheO9nn7SlpF1b6TNNZglf3BT'#10 +
      'SpFWP4xwB+RpjmHj1ClLg+hO1E/+olLfbIUplFqATpTWP7TGsgGBOhenQedzasq6'#10 +
      'qzEoEAiOx4x2kD0NLPGUzMZaUr8HTGriYePWC4SJgwFSGQ9V5Yf4g2zYVh0Kyr2V'#10 +
      'hJi9mJsGi3mBrgpxueabxEXnDdrDR1PiPhEPIU/w+63jZzcV/cvaKTSyvPtebPSy'#10 +
      '+AdMtR5r2HXtDoZUKLHfcWZ2LP794wM5WU7ZoIuAQGGKZZyULqneGzCNdvmMuWu8'#10 +
      '5wIDAQAB'#10 + '-----END PUBLIC KEY-----';
  private var
    FPubKeyFile : string;
    FPFXFile    : string;
    FPFXPass    : string;
    FSoapURL    : string;
    FSoapAction : string;
  private class var
    FInstance   : IAtWSvc;
  private
    procedure HTTPReqResp1BeforePost(const HTTPReqResp: THTTPReqResp; Data: Pointer);
  public
    constructor Create(const SoapURL, SoapAction, PFXFile, PFXPass, PubKeyFile: string);
    class function New(const SoapURL, SoapAction, PFXFile, PFXPass, PubKeyFile: string): IAtWSvc;
    function Send(const XMLData: WideString): WideString;
  end;

implementation

uses
    WinINet
  , Obj.SSI.TCertificate
  , SysUtils
  , Obj.SSI.TURL
  , Obj.SSI.TFile
  , Obj.SSI.TIf
  , Obj.SSI.TSoapRequest
  , Obj.SSI.IValue
  , Obj.SSI.TValue
  , AtXMLDocument
  ;

{ TAtWSvc }

constructor TAtWSvc.Create(const SoapURL, SoapAction, PFXFile, PFXPass, PubKeyFile: string);
begin
  FSoapURL    := SoapURL;
  FSoapAction := SoapAction;
  FPFXFile    := PFXFile;
  FPFXPass    := PFXPass;
  FPubKeyFile := PubKeyFile;
end;

class function TAtWSvc.New(const SoapURL, SoapAction, PFXFile, PFXPass, PubKeyFile: string): IAtWSvc;
begin
  Result := Create(SoapURL, SoapAction, PFXFile, PFXPass, PubKeyFile);
end;

procedure TAtWSvc.HTTPReqResp1BeforePost(const HTTPReqResp: THTTPReqResp; Data: Pointer);
begin
  with TCertificate.New(FPFXFile, FPFXPass) do
    if not (
            IsValid and
            InternetSetOption(
              Data,
              INTERNET_OPTION_CLIENT_CERT_CONTEXT,
              AsPCCert_Context,
              ContextSize
            )
           )
      then raise Exception.Create(
             'Problema no certificado:' + #10 +
             'Nº série: ' + SerialNumber + #10 +
             'Valido até: ' + FormatDateTime('yyyy-mm-dd', NotAfter)
           );
end;

function TAtWSvc.Send(const XMLData: WideString): WideString;
begin
  if not TURL.New(cATUrl).IsValid then
    raise Exception.Create('O servidor da AT não está a responder.');

  Result := WideString(
    TSoapRequest.New(
      FSoapURL,
      FSoapAction,
      HTTPReqResp1BeforePost
    ).Send(
        TAtXMLDocument.New(
          XMLData,
          TIf<IString>.New(
            FileExists(FPubKeyFile),
            TString.New(
              function: string
              begin
                Result := TFile.New(FPubKeyFile).AsDataStream.AsString;
              end
            ),
            TString.New(
              cATPublicKey
            )
          ).Eval.Value
        ).XML.Text
      )
  );
end;

end.
