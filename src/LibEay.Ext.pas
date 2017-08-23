unit LibEay.Ext;

interface

uses
    LibEay32
  ;

const
  cLibEay                 = 'LibEay32.dll';
  EVP_MAX_KEY_LENGTH      = 32;
  EVP_MAX_IV_LENGTH       = 16;
  EVP_MAX_BLOCK_LENGTH    = 32;
  BIO_FLAGS_BASE64_NO_NL  = $100;

type
  TNotImplemented = record end;
  PNotImplemented = ^TNotImplemented;
  PEVP_CIPHER = ^EVP_CIPHER;
  PEVP_CIPHER_CTX = ^EVP_CIPHER_CTX;

  EVP_CIPHER = record
    nid: Integer;
    block_size: Integer;
    key_len: Integer;		(* Default value for variable length ciphers *)
    iv_len: Integer;
    flags: LongWord;	(* Various flags *)
    init: function(ctx: PEVP_CIPHER_CTX; const key, iv: PAnsiChar; enc: Integer): Integer; cdecl; (* init key *)
    do_cipher: function(ctx: PEVP_CIPHER_CTX; out_: PAnsiChar; const in_: PAnsiChar; inl: Cardinal): Integer; cdecl; (* encrypt/decrypt data *)
    cleanup: function(ctx: PEVP_CIPHER_CTX): Integer; (* cleanup ctx *)
    ctx_size: Integer;		(* how big ctx->cipher_data needs to be *)
    set_asn1_parameters: function(ctx: PEVP_CIPHER_CTX; ASN1: PNotImplemented): Integer; cdecl; (* Populate a ASN1_TYPE with parameters *)
    get_asn1_parameters: function(ctx: PEVP_CIPHER_CTX; ASN1: PNotImplemented): Integer; cdecl; (* Get parameters from a ASN1_TYPE *)
    ctrl: function(ctx: PEVP_CIPHER_CTX; type_, arg: Integer; ptr: Pointer): Integer; cdecl; (* Miscellaneous operations *)
    app_data: Pointer;		(* Application data *)
  end;

  EVP_CIPHER_CTX = record
    cipher: PEVP_CIPHER;
    engine: PNotImplemented;	(* functional reference if 'cipher' is ENGINE-provided *)
    encrypt: Integer;		(* encrypt or decrypt *)
    buf_len: Integer;		(* number we have left *)

    oiv: array[0..EVP_MAX_IV_LENGTH-1] of AnsiChar;	(* original iv *)
    iv: array[0..EVP_MAX_IV_LENGTH-1] of AnsiChar; (* working iv *)
    buf: array[0..EVP_MAX_BLOCK_LENGTH-1] of AnsiChar; (* saved partial block *)
    num: Integer; (* used by cfb/ofb mode *)

    app_data: Pointer; (* application stuff *)
    key_len: Integer;	 (* May change for variable length cipher *)
    flags: LongWord;	(* Various flags *)
    cipher_data: Pointer; (* per EVP data *)
    final_used: Integer;
    block_mask: Integer;
    final: array[0..EVP_MAX_BLOCK_LENGTH-1] of AnsiChar; (* possible final block *)
	end;

function EVP_CipherInit_ex(ctx: PEVP_CIPHER_CTX; const cipher: PEVP_CIPHER;
  impl: PNotImplemented; const key, iv: PByte; enc: Integer): Integer; cdecl; external cLibEay;
procedure EVP_CIPHER_CTX_free(a: PEVP_CIPHER_CTX); cdecl; external cLibEay;
function EVP_CIPHER_CTX_block_size(const ctx: PEVP_CIPHER_CTX): Integer; cdecl; external cLibEay;
function EVP_CipherUpdate(ctx: PEVP_CIPHER_CTX; out_: Pointer;
  outl: PInteger; const in_: Pointer; inl: Integer): Integer; cdecl; external cLibEay;
function EVP_CipherFinal_ex(ctx: PEVP_CIPHER_CTX; outm: Pointer; outl: PInteger): Integer; cdecl; external cLibEay;
function EVP_CIPHER_CTX_key_length(const ctx: PEVP_CIPHER_CTX): Integer; cdecl; external cLibEay;
procedure BIO_set_flags(b: PBIO; flags: Integer); cdecl; external cLibEay;

implementation

end.
