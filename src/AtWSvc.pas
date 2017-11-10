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
    // ChaveCifraPublicaAT2020.pem, convertido do ChaveCifraPublicAT2020.cer via OpenSSL, válida até 2020-07-23
    cATPublicKey = '-----BEGIN PUBLIC KEY-----'#10 +
      'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEArBZr7ZqFlHJ8PtTJpXjT'#10 +
      'm7uilDw2dBIbhClYUh1HXMY72N6Kt4/Es+ZV12kERfjzI4FyqRb7Rpb7nD0gHDQf'#10 +
      'dwjs3DBZIUKM5TwH/eASUMCu/hl9RfzRvOtXEq2CfSA4dHv/MH+QJg6vbVO0+lHl'#10 +
      'u1jzybe7fFSxkHWtrfdpsacJRP+tRz9qQ2GS8Pbr7H51NdGHUAsm1A74DYJUyc3N'#10 +
      '4tMd4v1H2YVAsDqnmRqFFasMvyb5tzjwttAlBXeccb6PhFG6Px/NTjYUt87wQywo'#10 +
      'Gh2hqOG5Hwyx7RSidFKvXCQQnVAVxAwBhqgggqGf3eAujtTZMe+pdJPtM8x+P+vr'#10 +
      'FwIDAQAB'#10 + '-----END PUBLIC KEY-----';
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
  , SysUtils
  , AtXMLDocument
  , RO.TCertificate
  , RO.TURL
  , RO.TSoapRequest
  , RO.IValue
  , RO.TIf
  , RO.TValue
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
          TIf<string>.New(
            FileExists(FPubKeyFile),
            TFile.New(FPubKeyFile).AsDataStream.AsString,
            cATPublicKey
          ).Eval
        ).XML.Text
      )
  );
end;

end.
