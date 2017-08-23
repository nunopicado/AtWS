(******************************************************************************)
(** Suite         : AtWS                                                     **)
(** Object        :                                                          **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(******************************************************************************)
(** Dependencies  : OpenSSL, LibEay32, TZDB, Reusable Objects                **)
(******************************************************************************)
(** Description   : Extends LibEay32 OpenSSL wrapping                        **)
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

library AtWS;

uses
  AtXMLDocument in 'AtXMLDocument.pas',
  AtWSvc in 'AtWSvc.pas',
  TZDB in 'ThirdParty\TZDB\TZDB.pas',
  libeay32 in 'ThirdParty\OpenSSL\libeay32.pas',
  Obj.SSI.IAES128 in 'ThirdParty\ReusableObjects\Obj.SSI.IAES128.pas',
  Obj.SSI.IDataStream in 'ThirdParty\ReusableObjects\Obj.SSI.IDataStream.pas',
  Obj.SSI.IDate in 'ThirdParty\ReusableObjects\Obj.SSI.IDate.pas',
  Obj.SSI.IFile in 'ThirdParty\ReusableObjects\Obj.SSI.IFile.pas',
  Obj.SSI.IIf in 'ThirdParty\ReusableObjects\Obj.SSI.IIf.pas',
  Obj.SSI.IRandomKey in 'ThirdParty\ReusableObjects\Obj.SSI.IRandomKey.pas',
  Obj.SSI.IRSASignature in 'ThirdParty\ReusableObjects\Obj.SSI.IRSASignature.pas',
  Obj.SSI.ISNTPTime in 'ThirdParty\ReusableObjects\Obj.SSI.ISNTPTime.pas',
  Obj.SSI.ISoapRequest in 'ThirdParty\ReusableObjects\Obj.SSI.ISoapRequest.pas',
  Obj.SSI.IURL in 'ThirdParty\ReusableObjects\Obj.SSI.IURL.pas',
  Obj.SSI.IValue in 'ThirdParty\ReusableObjects\Obj.SSI.IValue.pas',
  Obj.SSI.IZDate in 'ThirdParty\ReusableObjects\Obj.SSI.IZDate.pas',
  Obj.SSI.TAES128 in 'ThirdParty\ReusableObjects\Obj.SSI.TAES128.pas',
  Obj.SSI.TDataStream in 'ThirdParty\ReusableObjects\Obj.SSI.TDataStream.pas',
  Obj.SSI.TDate in 'ThirdParty\ReusableObjects\Obj.SSI.TDate.pas',
  Obj.SSI.TFile in 'ThirdParty\ReusableObjects\Obj.SSI.TFile.pas',
  Obj.SSI.TIf in 'ThirdParty\ReusableObjects\Obj.SSI.TIf.pas',
  Obj.SSI.TRandomKey in 'ThirdParty\ReusableObjects\Obj.SSI.TRandomKey.pas',
  Obj.SSI.TRSASignature in 'ThirdParty\ReusableObjects\Obj.SSI.TRSASignature.pas',
  Obj.SSI.TSNTPTime in 'ThirdParty\ReusableObjects\Obj.SSI.TSNTPTime.pas',
  Obj.SSI.TSoapRequest in 'ThirdParty\ReusableObjects\Obj.SSI.TSoapRequest.pas',
  Obj.SSI.TURL in 'ThirdParty\ReusableObjects\Obj.SSI.TURL.pas',
  Obj.SSI.TValue in 'ThirdParty\ReusableObjects\Obj.SSI.TValue.pas',
  Obj.SSI.TZDate in 'ThirdParty\ReusableObjects\Obj.SSI.TZDate.pas',
  AtWSvcIntf in 'AtWSvcIntf.pas',
  Obj.SSI.ICertificate in 'ThirdParty\ReusableObjects\Obj.SSI.ICertificate.pas',
  Obj.SSI.TCertificate in 'ThirdParty\ReusableObjects\Obj.SSI.TCertificate.pas',
  LibEay.Ext in 'LibEay.Ext.pas';

{$R *.res}

function ATWebService(const SoapURL, SoapAction, PubKeyFile, PFXFile, PFXPass: WideString): IAtWSvc; stdcall; export;
begin
  Result := TAtWSvc.New(
    SoapURL,
    SoapAction,
    PFXFile,
    PFXPass,
    PubKeyFile
  );
end;

exports
    ATWebService
  ;

begin
end.

