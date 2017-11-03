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
  AtWSvcIntf in 'AtWSvcIntf.pas',
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

