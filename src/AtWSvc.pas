(******************************************************************************)
(** Suite         : AtWS                                                     **)
(** Object        : TAtWSvc                                                  **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : IAtWSvc                                                  **)
(******************************************************************************)
(** Dependencies  :                                                          **)
(******************************************************************************)
(** Description   : Sends a XML request to a webservice, and returns its     **)
(**                 response                                                 **)
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
    // ChaveCifraPublicaAT2023.pem, convertido do ChaveCifraPublicAT2023.cer via OpenSSL, válida até 2023-06-23
    cATPublicKey = '-----BEGIN PUBLIC KEY-----'#10 +
      'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAg4twIjlr5yckmYpVvGkc'#10 +
      'yxt3rqvoQFMn+s4f89ZFnFJESv0my/qDiV1Tg8EDTxHcxEUIqM9ER8+inYJnfxoo'#10 +
      'czhr35zmoyVbiNkZy7ORtFZbMD1qDtVL+aBJvAKV50c8ZwbkV+aSzvY2p15I1u2r'#10 +
      'EKixFVqswwqo0kHbSgVfCW+x9xMT1QChlk9eYDEJ5/ugJD3e3q1YWCnVsGxtLiSc'#10 +
      '8MI5KJdlBbd2lshOXC02LTNryjDEj61s5Qz8AUaEtrK8BxXH0WQB5hjVBmBLKE2k'#10 +
      'Oh6L6iSeNHgnJg3RyrjaV1wzBJPbuo9r/HCVubfY+MqE444niC1d4u9DA8Wn44Eo'#10 +
      'KwIDAQAB'#10 + '-----END PUBLIC KEY-----';
  private var
    FPubKeyFile : string;
    FPFXFile    : string;
    FPFXPass    : string;
    FSoapURL    : string;
    FSoapAction : string;
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
  , SysUtils
  , AtXMLDocument
  , RO.TCertificate
  , RO.TURL
  , RO.TSoapRequest
  , RO.TIf
  , RO.TFile
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
var
  PubKey: string;
begin
  if not TURL.New(cATUrl).IsValid then
    raise Exception.Create('O servidor da AT não está a responder.');

  if FileExists(FPubKeyFile)
    then PubKey := TFile.New(FPubKeyFile).AsDataStream.AsString
    else PubKey := cATPublicKey;

  Result := WideString(
    TSoapRequest.New(
      FSoapURL,
      FSoapAction,
      HTTPReqResp1BeforePost
    ).Send(
        TAtXMLDocument.New(
          XMLData,
          PubKey
        ).XML.Text
      )
  );
end;

end.
