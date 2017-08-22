unit Obj.SSI.TAES128;

interface

uses
    Obj.SSI.IAES128
  , Obj.SSI.IValue
  ;

type
  TAES128 = class(TInterfacedObject, IAES128)
  private
    FSecretKey: string;
    FStrIn: string;
    FOut: IString;
    function AESEncrypt: string;
  public
    constructor Create(const SecretKey, StrIn: string);
    class function New(const SecretKey, StrIn: string): IAES128;
    function AsString: string;
  end;

implementation

uses
    Obj.SSI.TValue
  , dorOpenSSLCipher
  ;

{ TAES }

function TAES128.AsString: string;
begin

  Result := FOut.Value;
end;

constructor TAES128.Create(const SecretKey, StrIn: string);
begin
  FSecretKey := SecretKey;
  FStrIn     := StrIn;
  FOut       := TString.New(AESEncrypt);
end;

class function TAES128.New(const SecretKey, StrIn: string): IAES128;
begin
  Result := Create(SecretKey, StrIn);
end;

function TAES128.AESEncrypt: string;
var
  Cipher: TCipher;
  StrOut: RawByteString;
begin
  Cipher := TCipher.Create('aes-128-ecb');
  try
    Cipher.Encrypt;
    Cipher.set_key(RawByteString(FSecretKey));
    StrOut := Cipher.update(RawByteString(FStrIn)) + Cipher.final;
    StrOut := EncodeBase64(StrOut);
    Result := string(StrOut);
  finally
    Cipher.Free;
  end;
end;

end.
