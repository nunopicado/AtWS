unit Obj.SSI.TRandomKey;

interface

uses
    Obj.SSI.IRandomKey
  , Obj.SSI.IValue
  ;

type
  TRandomKey = class(TInterfacedObject, IRandomKey)
  private
    FKey: IString;
    function Generate: string;
  public
    constructor Create(const NumberOfBits: Byte);
    class function New(const NumberOfBits: Byte = 16): IRandomKey;
    function AsString: string;
  end;

implementation

uses
    SysUtils
  , StrUtils
  , Obj.SSI.TValue
  , Windows
  ;

function TRandomKey.AsString: string;
begin
  Result := FKey.Value;
end;

constructor TRandomKey.Create(const NumberOfBits: Byte);
begin
  FKey := TString.New(Generate);
end;

function TRandomKey.Generate: string;
type
  TStringArray = array [1..6] of string;
var
  i, j: Byte;
  v: NativeInt;
  s: TStringArray;
begin
  Randomize;

  Result := '';
  s      := Default(TStringArray);
  for i := 1 to 16 do
    for j := Low(s) to High(s) do
      s[j] := s[j] + Random(9).ToString;
  for i := 1 to 16 do
    begin
      v := 0;
      for j := Low(s) to High(s) do
        Inc(v, StrToInt(s[j][i]));
      Result := Result + RightStr(v.ToString, 1);
    end;
end;

class function TRandomKey.New(const NumberOfBits: Byte): IRandomKey;
begin
  Result := Create(NumberOfBits);
end;

end.
