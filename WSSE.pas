unit WSSE;

interface

uses SysUtils, InvokeRegistry, SOAPHTTPClient, Types, XSBuiltIns,XMLIntf;

const
  IS_OPTN = $0001;
  IS_ATTR = $0010;
  IS_TEXT = $0020;
  IS_REF  = $0080;

type
  XPathSoap            = class;                 { "http://schemas.xmlsoap.org/ws/2002/12/secext"[GblCplx] }
  MessageParts         = class;                 { "http://schemas.xmlsoap.org/ws/2002/12/secext"[GblElm] }
  AttributedString     = class;                 { "http://schemas.xmlsoap.org/ws/2002/12/secext"[GblCplx] }
  EncodedString        = class;                 { "http://schemas.xmlsoap.org/ws/2002/12/secext"[GblCplx] }
  KeyIdentifierType    = class;                 { "http://schemas.xmlsoap.org/ws/2002/12/secext"[GblCplx] }
  KeyIdentifier        = class;                 { "http://schemas.xmlsoap.org/ws/2002/12/secext"[GblElm] }
  BinarySecurityTokenType = class;              { "http://schemas.xmlsoap.org/ws/2002/12/secext"[GblCplx] }
  BinarySecurityToken  = class;                 { "http://schemas.xmlsoap.org/ws/2002/12/secext"[GblElm] }
  Nonce                = class;                 { "http://schemas.xmlsoap.org/ws/2002/12/secext"[GblElm] }
  PasswordString       = class;                 { "http://schemas.xmlsoap.org/ws/2002/12/secext"[GblCplx] }
  Password             = class;                 { "http://schemas.xmlsoap.org/ws/2002/12/secext"[GblElm] }
  AttributedURI        = class;                 { "http://schemas.xmlsoap.org/ws/2002/07/utility"[GblCplx] }
  Identifier           = class;                 { "http://schemas.xmlsoap.org/ws/2002/07/utility"[GblElm] }
  AttributedDateTime   = class;                 { "http://schemas.xmlsoap.org/ws/2002/07/utility"[GblCplx] }
  ReceivedType         = class;                 { "http://schemas.xmlsoap.org/ws/2002/07/utility"[GblCplx] }
  Received             = class;                 { "http://schemas.xmlsoap.org/ws/2002/07/utility"[GblElm] }
  Created              = class;                 { "http://schemas.xmlsoap.org/ws/2002/07/utility"[GblElm] }
  Expires              = class;                 { "http://schemas.xmlsoap.org/ws/2002/07/utility"[GblElm] }
  BinaryNegotiation    = class;                 { "http://schemas.xmlsoap.org/ws/2002/12/secext"[GblElm] }
  MessagePredicateAssertion = class;            { "http://schemas.xmlsoap.org/ws/2002/12/policy"[GblCplx] }
  MessagePredicate     = class;                 { "http://schemas.xmlsoap.org/ws/2002/12/policy"[GblElm] }


  SignerType      =  type string;      { "http://schemas.xmlsoap.org/ws/2002/12/secext"[GblSmpl] }


  // ************************************************************************ //
  // XML       : XPathSoap, global, <complexType>
  // Namespace : http://schemas.xmlsoap.org/ws/2002/12/secext
  // ************************************************************************ //
  XPathSoap = class(TRemotable)
  private
    FText: string;
    FDialect: string;
    FDialect_Specified: boolean;
    FSigner: SignerType;
    FSigner_Specified: boolean;
    procedure SetDialect(Index: Integer; const Astring: string);
    function  Dialect_Specified(Index: Integer): boolean;
    procedure SetSigner(Index: Integer; const ASignerType: SignerType);
    function  Signer_Specified(Index: Integer): boolean;
  published
    property Text:    string      Index (IS_TEXT) read FText write FText;
    property Dialect: string      Index (IS_ATTR or IS_OPTN) read FDialect write SetDialect stored Dialect_Specified;
    property Signer:  SignerType  Index (IS_ATTR or IS_OPTN) read FSigner write SetSigner stored Signer_Specified;
  end;



  // ************************************************************************ //
  // XML       : MessageParts, global, <element>
  // Namespace : http://schemas.xmlsoap.org/ws/2002/12/secext
  // ************************************************************************ //
  MessageParts = class(XPathSoap)
  private
  published
  end;


  OpenUsageType   =  type string;      { "http://schemas.xmlsoap.org/ws/2002/12/policy"[GblSmpl] }
  Preference      =  type Integer;      { "http://schemas.xmlsoap.org/ws/2002/12/policy"[GblAttr] }
  Id              =  type string;      { "http://schemas.xmlsoap.org/ws/2002/07/utility"[GblAttr] }


  // ************************************************************************ //
  // XML       : AttributedString, global, <complexType>
  // Namespace : http://schemas.xmlsoap.org/ws/2002/12/secext
  // ************************************************************************ //
  AttributedString = class(TRemotable)
  private
    FText: string;
    FId: Id;
    FId_Specified: boolean;
    procedure SetId(Index: Integer; const AId: Id);
    function  Id_Specified(Index: Integer): boolean;
  published
    property Text: string  Index (IS_TEXT) read FText write FText;
    property Id:   Id      Index (IS_ATTR or IS_OPTN) read FId write SetId stored Id_Specified;
  end;



  // ************************************************************************ //
  // XML       : EncodedString, global, <complexType>
  // Namespace : http://schemas.xmlsoap.org/ws/2002/12/secext
  // ************************************************************************ //
  EncodedString = class(AttributedString)
  private
    FEncodingType: string;
    FEncodingType_Specified: boolean;
    procedure SetEncodingType(Index: Integer; const Astring: string);
    function  EncodingType_Specified(Index: Integer): boolean;
  published
    property EncodingType: string  Index (IS_ATTR or IS_OPTN) read FEncodingType write SetEncodingType stored EncodingType_Specified;
  end;



  // ************************************************************************ //
  // XML       : KeyIdentifierType, global, <complexType>
  // Namespace : http://schemas.xmlsoap.org/ws/2002/12/secext
  // ************************************************************************ //
  KeyIdentifierType = class(EncodedString)
  private
    FValueType: string;
    FValueType_Specified: boolean;
    procedure SetValueType(Index: Integer; const Astring: string);
    function  ValueType_Specified(Index: Integer): boolean;
  published
    property ValueType: string  Index (IS_ATTR or IS_OPTN) read FValueType write SetValueType stored ValueType_Specified;
  end;



  // ************************************************************************ //
  // XML       : KeyIdentifier, global, <element>
  // Namespace : http://schemas.xmlsoap.org/ws/2002/12/secext
  // ************************************************************************ //
  KeyIdentifier = class(KeyIdentifierType)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : BinarySecurityTokenType, global, <complexType>
  // Namespace : http://schemas.xmlsoap.org/ws/2002/12/secext
  // ************************************************************************ //
  BinarySecurityTokenType = class(EncodedString)
  private
    FValueType: string;
    FValueType_Specified: boolean;
    procedure SetValueType(Index: Integer; const Astring: string);
    function  ValueType_Specified(Index: Integer): boolean;
  published
    property ValueType: string  Index (IS_ATTR or IS_OPTN) read FValueType write SetValueType stored ValueType_Specified;
  end;



  // ************************************************************************ //
  // XML       : BinarySecurityToken, global, <element>
  // Namespace : http://schemas.xmlsoap.org/ws/2002/12/secext
  // ************************************************************************ //
  BinarySecurityToken = class(BinarySecurityTokenType)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : Nonce, global, <element>
  // Namespace : http://schemas.xmlsoap.org/ws/2002/12/secext
  // ************************************************************************ //
  Nonce = class(EncodedString)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : PasswordString, global, <complexType>
  // Namespace : http://schemas.xmlsoap.org/ws/2002/12/secext
  // ************************************************************************ //
  PasswordString = class(AttributedString)
  private
    FType_: string;
    FType__Specified: boolean;
    procedure SetType_(Index: Integer; const Astring: string);
    function  Type__Specified(Index: Integer): boolean;
  published
    property Type_: string  Index (IS_ATTR or IS_OPTN) read FType_ write SetType_ stored Type__Specified;
  end;



  // ************************************************************************ //
  // XML       : Password, global, <element>
  // Namespace : http://schemas.xmlsoap.org/ws/2002/12/secext
  // ************************************************************************ //
  Password = class(PasswordString)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : AttributedURI, global, <complexType>
  // Namespace : http://schemas.xmlsoap.org/ws/2002/07/utility
  // ************************************************************************ //
  AttributedURI = class(TRemotable)
  private
    FText: string;
    FId: Id;
    FId_Specified: boolean;
    procedure SetId(Index: Integer; const AId: Id);
    function  Id_Specified(Index: Integer): boolean;
  published
    property Text: string  Index (IS_TEXT) read FText write FText;
    property Id:   Id      Index (IS_ATTR or IS_OPTN) read FId write SetId stored Id_Specified;
  end;



  // ************************************************************************ //
  // XML       : Identifier, global, <element>
  // Namespace : http://schemas.xmlsoap.org/ws/2002/07/utility
  // ************************************************************************ //
  Identifier = class(AttributedURI)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : AttributedDateTime, global, <complexType>
  // Namespace : http://schemas.xmlsoap.org/ws/2002/07/utility
  // ************************************************************************ //
  AttributedDateTime = class(TRemotable)
  private
    FText: string;
    FValueType: string;
    FValueType_Specified: boolean;
    FId: Id;
    FId_Specified: boolean;
    procedure SetValueType(Index: Integer; const Astring: string);
    function  ValueType_Specified(Index: Integer): boolean;
    procedure SetId(Index: Integer; const AId: Id);
    function  Id_Specified(Index: Integer): boolean;
  published
    property Text:      string  Index (IS_TEXT) read FText write FText;
    property ValueType: string  Index (IS_ATTR or IS_OPTN) read FValueType write SetValueType stored ValueType_Specified;
    property Id:        Id      Index (IS_ATTR or IS_OPTN) read FId write SetId stored Id_Specified;
  end;



  // ************************************************************************ //
  // XML       : ReceivedType, global, <complexType>
  // Namespace : http://schemas.xmlsoap.org/ws/2002/07/utility
  // ************************************************************************ //
  ReceivedType = class(AttributedDateTime)
  private
    FDelay: Integer;
    FDelay_Specified: boolean;
    FActor: string;
    procedure SetDelay(Index: Integer; const AInteger: Integer);
    function  Delay_Specified(Index: Integer): boolean;
  published
    property Delay: Integer  Index (IS_ATTR or IS_OPTN) read FDelay write SetDelay stored Delay_Specified;
    property Actor: string   Index (IS_ATTR) read FActor write FActor;
  end;



  // ************************************************************************ //
  // XML       : Received, global, <element>
  // Namespace : http://schemas.xmlsoap.org/ws/2002/07/utility
  // ************************************************************************ //
  Received = class(ReceivedType)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : Created, global, <element>
  // Namespace : http://schemas.xmlsoap.org/ws/2002/07/utility
  // ************************************************************************ //
  Created = class(AttributedDateTime)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : Expires, global, <element>
  // Namespace : http://schemas.xmlsoap.org/ws/2002/07/utility
  // ************************************************************************ //
  Expires = class(AttributedDateTime)
  private
  published
  end;



  // ************************************************************************ //
  // XML       : BinaryNegotiation, global, <element>
  // Namespace : http://schemas.xmlsoap.org/ws/2002/12/secext
  // ************************************************************************ //
  BinaryNegotiation = class(BinarySecurityTokenType)
  private
  published
  end;

  Usage           =  type OpenUsageType;      { "http://schemas.xmlsoap.org/ws/2002/12/policy"[GblAttr] }


  // ************************************************************************ //
  // XML       : MessagePredicateAssertion, global, <complexType>
  // Namespace : http://schemas.xmlsoap.org/ws/2002/12/policy
  // ************************************************************************ //
  MessagePredicateAssertion = class(TRemotable)
  private
    FText: string;
    FDialect: string;
    FDialect_Specified: boolean;
    FUsage: Usage;
    FUsage_Specified: boolean;
    FPreference: Preference;
    FPreference_Specified: boolean;
    FId: Id;
    FId_Specified: boolean;
    procedure SetDialect(Index: Integer; const Astring: string);
    function  Dialect_Specified(Index: Integer): boolean;
    procedure SetUsage(Index: Integer; const AUsage: Usage);
    function  Usage_Specified(Index: Integer): boolean;
    procedure SetPreference(Index: Integer; const APreference: Preference);
    function  Preference_Specified(Index: Integer): boolean;
    procedure SetId(Index: Integer; const AId: Id);
    function  Id_Specified(Index: Integer): boolean;
  published
    property Text:       string      Index (IS_TEXT) read FText write FText;
    property Dialect:    string      Index (IS_ATTR or IS_OPTN) read FDialect write SetDialect stored Dialect_Specified;
    property Usage:      Usage       Index (IS_ATTR or IS_OPTN) read FUsage write SetUsage stored Usage_Specified;
    property Preference: Preference  Index (IS_ATTR or IS_OPTN) read FPreference write SetPreference stored Preference_Specified;
    property Id:         Id          Index (IS_ATTR or IS_OPTN) read FId write SetId stored Id_Specified;
  end;



  // ************************************************************************ //
  // XML       : MessagePredicate, global, <element>
  // Namespace : http://schemas.xmlsoap.org/ws/2002/12/policy
  // ************************************************************************ //
  MessagePredicate = class(MessagePredicateAssertion)
  private
  published
  end;



  // ************************************************************************ //
  // XML : UsernameTokenType, global, <complexType>
  // Namespace : http://schemas.xmlsoap.org/ws/2002/12/secext
  // ************************************************************************ //
  UsernameTokenType = class(TRemotable)
  private
    FUsername: AttributedString;
    FPassword: Password;
    FNonce: Nonce;
    FCreated: Created;
//    FUsername: String;
//    FPassword: String;
//    FNonce: String;
//    FCreated: String;
    //procedure SetId(Index: Integer; const AId: WideString);
    //function Id_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property Username: AttributedString read FUsername write FUsername;
    property Password: Password read FPassword write FPassword;
    property Nonce: Nonce read FNonce write FNonce;
    property Created: Created read FCreated write FCreated;
//    property Username: String read FUsername write FUsername;
//    property Password: String read FPassword write FPassword;
//    property Nonce: String read FNonce write FNonce;
//    property Created: String read FCreated write FCreated;
  end;
  // ************************************************************************ //
  // XML : UsernameToken, global, <element>
  // Namespace : http://schemas.xmlsoap.org/ws/2002/07/secext
  // ************************************************************************ //
  UsernameToken = class(UsernameTokenType)
  private
  published
  end;

  Security=class(TSOAPHeader)
  private
    FUserNameToken:UserNameToken;
  public
    destructor Destroy; override;
  published
    property UsernameToken:UsernameToken index (IS_REF) read FUserNameToken write FUserNameToken;
  end;


implementation

destructor UsernameTokenType.Destroy;
begin
  SysUtils.FreeAndNil(FUsername);
  SysUtils.FreeAndNil(FPassword);
  SysUtils.FreeAndNil(FNonce);
  SysUtils.FreeAndNil(FCreated);
  inherited Destroy;
end;

destructor Security.Destroy;
begin
  FreeAndNIL(FUserNameToken);
  inherited Destroy;
end;

procedure XPathSoap.SetDialect(Index: Integer; const Astring: string);
begin
  FDialect := Astring;
  FDialect_Specified := True;
end;

function XPathSoap.Dialect_Specified(Index: Integer): boolean;
begin
  Result := FDialect_Specified;
end;

procedure XPathSoap.SetSigner(Index: Integer; const ASignerType: SignerType);
begin
  FSigner := ASignerType;
  FSigner_Specified := True;
end;

function XPathSoap.Signer_Specified(Index: Integer): boolean;
begin
  Result := FSigner_Specified;
end;

procedure AttributedString.SetId(Index: Integer; const AId: Id);
begin
  FId := AId;
  FId_Specified := True;
end;

function AttributedString.Id_Specified(Index: Integer): boolean;
begin
  Result := FId_Specified;
end;

procedure EncodedString.SetEncodingType(Index: Integer; const Astring: string);
begin
  FEncodingType := Astring;
  FEncodingType_Specified := True;
end;

function EncodedString.EncodingType_Specified(Index: Integer): boolean;
begin
  Result := FEncodingType_Specified;
end;

procedure KeyIdentifierType.SetValueType(Index: Integer; const Astring: string);
begin
  FValueType := Astring;
  FValueType_Specified := True;
end;

function KeyIdentifierType.ValueType_Specified(Index: Integer): boolean;
begin
  Result := FValueType_Specified;
end;

procedure BinarySecurityTokenType.SetValueType(Index: Integer; const Astring: string);
begin
  FValueType := Astring;
  FValueType_Specified := True;
end;

function BinarySecurityTokenType.ValueType_Specified(Index: Integer): boolean;
begin
  Result := FValueType_Specified;
end;

procedure PasswordString.SetType_(Index: Integer; const Astring: string);
begin
  FType_ := Astring;
  FType__Specified := True;
end;

function PasswordString.Type__Specified(Index: Integer): boolean;
begin
  Result := FType__Specified;
end;

procedure AttributedURI.SetId(Index: Integer; const AId: Id);
begin
  FId := AId;
  FId_Specified := True;
end;

function AttributedURI.Id_Specified(Index: Integer): boolean;
begin
  Result := FId_Specified;
end;

procedure AttributedDateTime.SetValueType(Index: Integer; const Astring: string);
begin
  FValueType := Astring;
  FValueType_Specified := True;
end;

function AttributedDateTime.ValueType_Specified(Index: Integer): boolean;
begin
  Result := FValueType_Specified;
end;

procedure AttributedDateTime.SetId(Index: Integer; const AId: Id);
begin
  FId := AId;
  FId_Specified := True;
end;

function AttributedDateTime.Id_Specified(Index: Integer): boolean;
begin
  Result := FId_Specified;
end;

procedure ReceivedType.SetDelay(Index: Integer; const AInteger: Integer);
begin
  FDelay := AInteger;
  FDelay_Specified := True;
end;

function ReceivedType.Delay_Specified(Index: Integer): boolean;
begin
  Result := FDelay_Specified;
end;

procedure MessagePredicateAssertion.SetDialect(Index: Integer; const Astring: string);
begin
  FDialect := Astring;
  FDialect_Specified := True;
end;

function MessagePredicateAssertion.Dialect_Specified(Index: Integer): boolean;
begin
  Result := FDialect_Specified;
end;

procedure MessagePredicateAssertion.SetUsage(Index: Integer; const AUsage: Usage);
begin
  FUsage := AUsage;
  FUsage_Specified := True;
end;

function MessagePredicateAssertion.Usage_Specified(Index: Integer): boolean;
begin
  Result := FUsage_Specified;
end;

procedure MessagePredicateAssertion.SetPreference(Index: Integer; const APreference: Preference);
begin
  FPreference := APreference;
  FPreference_Specified := True;
end;

function MessagePredicateAssertion.Preference_Specified(Index: Integer): boolean;
begin
  Result := FPreference_Specified;
end;

procedure MessagePredicateAssertion.SetId(Index: Integer; const AId: Id);
begin
  FId := AId;
  FId_Specified := True;
end;

function MessagePredicateAssertion.Id_Specified(Index: Integer): boolean;
begin
  Result := FId_Specified;
end;

initialization
  RemClassRegistry.RegisterXSClass(Security, 'http://schemas.xmlsoap.org/ws/2002/12/secext', 'Security');
  RemClassRegistry.RegisterXSClass(UsernameToken, 'http://schemas.xmlsoap.org/ws/2002/12/secext', 'wss:UsernameToken');
  RemClassRegistry.RegisterXSClass(UsernameTokenType, 'http://schemas.xmlsoap.org/ws/2002/12/secext', 'UsernameTokenType');
  RemClassRegistry.RegisterXSInfo(TypeInfo(SignerType), 'http://schemas.xmlsoap.org/ws/2002/12/secext', 'SignerType');
  RemClassRegistry.RegisterXSClass(XPathSoap, 'http://schemas.xmlsoap.org/ws/2002/12/secext', 'XPathSoap');
  RemClassRegistry.RegisterXSClass(MessageParts, 'http://schemas.xmlsoap.org/ws/2002/12/secext', 'MessageParts');
  RemClassRegistry.RegisterXSClass(AttributedString, 'http://schemas.xmlsoap.org/ws/2002/12/secext', 'AttributedString');
  RemClassRegistry.RegisterXSClass(EncodedString, 'http://schemas.xmlsoap.org/ws/2002/12/secext', 'EncodedString');
  RemClassRegistry.RegisterXSClass(KeyIdentifierType, 'http://schemas.xmlsoap.org/ws/2002/12/secext', 'KeyIdentifierType');
  RemClassRegistry.RegisterXSClass(KeyIdentifier, 'http://schemas.xmlsoap.org/ws/2002/12/secext', 'KeyIdentifier');
  RemClassRegistry.RegisterXSClass(BinarySecurityTokenType, 'http://schemas.xmlsoap.org/ws/2002/12/secext', 'BinarySecurityTokenType');
  RemClassRegistry.RegisterXSClass(BinarySecurityToken, 'http://schemas.xmlsoap.org/ws/2002/12/secext', 'BinarySecurityToken');
  RemClassRegistry.RegisterXSClass(Nonce, 'http://schemas.xmlsoap.org/ws/2002/12/secext', 'Nonce');
  RemClassRegistry.RegisterXSClass(PasswordString, 'http://schemas.xmlsoap.org/ws/2002/12/secext', 'PasswordString');
  RemClassRegistry.RegisterXSClass(Password, 'http://schemas.xmlsoap.org/ws/2002/12/secext', 'Password');
  RemClassRegistry.RegisterXSClass(BinaryNegotiation, 'http://schemas.xmlsoap.org/ws/2002/12/secext', 'BinaryNegotiation');

end.

