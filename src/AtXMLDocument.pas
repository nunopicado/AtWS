(******************************************************************************)
(** Suite         : AtWS                                                     **)
(** Object        : TAtXMLDocument                                           **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(******************************************************************************)
(** Dependencies  :                                                          **)
(******************************************************************************)
(** Description   : Customized version of TXMLDocument, capable of setting   **)
(**                 up by itself the fields Nonce, Password and Created      **)
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

unit AtXMLDocument;

interface

uses
    XMLDoc
  , xmlintf
  ;

type
  TAtXMLDocument = class(TXMLDocument)
  public
    class function New(const XMLData, PubKey: string): IXMLDocument;
  end;

implementation

uses
    RO.TAES128
  , RO.TZDate
  , RO.ISNTPTime
  , RO.TSNTPTime
  , RO.TIf
  , RO.TValue
  , RO.TRSASignature
  , RO.TRandomKey
  , SysUtils
  ;

{ TAtXMLDocument }

class function TAtXMLDocument.New(const XMLData, PubKey: string): IXMLDocument;
const
  RandomKeyBitNumber = 16;
var
  CurNode   : IXMLNode;
  SecretKey : string;
begin
  Result            := NewXMLDocument;
  Result.Encoding   := 'utf-8';
  Result.StandAlone := 'no';
  Result.Options    := [doNodeAutoIndent];
  Result.LoadFromXML(XMLData);

  SecretKey := TRandomKey.New(RandomKeyBitNumber).AsString;

  with Result.DocumentElement.ChildNodes[0].ChildNodes[0].ChildNodes[0].ChildNodes do
    begin
      // Nonce
      CurNode := FindNode('Nonce');
      if Assigned(CurNode) then
        CurNode.Text := TRSASignature.New(
            SecretKey,
            PubKey
          ).AsString;

      // Password
      CurNode := FindNode('Password');
      if Assigned(CurNode) then
        CurNode.Text := TAES128.New(
          SecretKey,
          CurNode.Text
        ).AsString;

      // Created
      CurNode := FindNode('Created');
      if Assigned(CurNode) then
        CurNode.Text := TAES128.New(
          SecretKey,
          TZDate.New(
            'Portugal',
            TSNTPTimePool.New(
              [
                'ntp04.oal.ul.pt',
                'ntp02.oal.ul.pt'
              ],
              TSPBehavior.spReturnCurrentDate
            )
          ).AsString
        ).AsString
    end;
end;

end.
