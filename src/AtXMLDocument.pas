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
    Obj.SSI.TAES128
  , Obj.SSI.TZDate
  , Obj.SSI.ISNTPTime
  , Obj.SSI.TSNTPTime
  , Obj.SSI.TIf
  , Obj.SSI.TRSASignature
  , Obj.SSI.TRandomKey
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
