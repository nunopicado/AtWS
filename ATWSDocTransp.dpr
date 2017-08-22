library ATWSDocTransp;

uses
  System.SysUtils,
  System.Classes,
  WinInet,
  Windows,
  StrUtils,
  XSBuiltIns,
  idSNTP,
  DateUtils,
  SOAPHTTPTrans,
  Soap.Win.CertHelper,
  dorOpenSSLCipher,
  XMLDoc,
  xmlintf,
  ActiveX,
  Dialogs,
  CAPICOM_TLB in 'CAPICOM_TLB.pas',
  libeay32 in 'libeay32.pas',
  superobject in 'superobject.pas',
  TZDB in 'TZDB.pas';

type
    THTTPEvents = Class
      FPubKeyFile:String;
      FPFXFile:String;
      FPFXPass:String;
    Public
      property PubKeyFile:String Read FPubKeyFile Write FPubKeyFile;
      property PFXFile:String Read FPFXFile Write FPFXFile;
      property PFXPass:String Read FPFXPass Write FPFXPass;
      procedure HTTPReqResp1BeforePost(const HTTPReqResp: THTTPReqResp; Data: Pointer);
    End;

const
     INTERNET_OPTION_CLIENT_CERT_CONTEXT=84;

var
   HTTPEvents:THTTPEvents;
   SecretKey:String;
   cATUrl:String='https://faturas.portaldasfinancas.gov.pt/';
   cSoapUrl:String='https://servicos.portaldasfinancas.gov.pt:401/sgdtws/documentosTransporte';
   cSoapAction:String='https://servicos.portaldasfinancas.gov.pt/sgdtws/documentosTransporte/';

{$R *.res}

procedure InitWS(SoapURL,SoapAction:WideString); StdCall; Export;
begin
     cSoapUrl:=SoapUrl;
     cSoapAction:=SoapAction;
end;

function EchoURL:WideString; StdCall; Export;
begin
     Result:=WideString(cSoapUrl);
end;

function GenerateRandomKey: String;
var
   s1, s2, s3, s4, s5, s6, Key: String;
   i, v: NativeInt;
begin
     try
        Randomize;
        s1 := ''; s2 := ''; s3 := ''; s4 := ''; s5 := ''; s6 := '';
        for i := 1 to 16 do
            begin
                 s1 := s1 + IntToStr(Random(9));
                 s2 := s2 + IntToStr(Random(9));
                 s3 := s3 + IntToStr(Random(9));
                 s4 := s4 + IntToStr(Random(9));
                 s5 := s5 + IntToStr(Random(9));
                 s6 := s6 + IntToStr(Random(9));
            end;
        Key := '';
        for i := 1 to 16 do
            begin
                 v := StrToInt(s1[i]) + StrToInt(s2[i]) + StrToInt(s3[i]) + StrToInt(s4[i]) + StrToInt(s5[i]) + StrToInt(s6[i]);
                 Key := Key + RightStr(IntToStr(v), 1);
            end;
        Result := Key;
     except
        ON E:Exception DO
           ShowMessage(E.Message);
     end;
end;

function AESEncString(sIn: String): String;
var
   Cipher: TCipher;
   sOut: RawByteString;
begin
     try
        Cipher := TCipher.Create('aes-128-ecb');
        Cipher.encrypt;
        Cipher.set_key(RawByteString(SecretKey));
        sOut := Cipher.update(RawByteString(sIn)) + Cipher.final;
        sOut := EncodeBase64(sOut);
        Result := String(sOut);
        Cipher.Free;
     except
        ON E:Exception DO
           ShowMessage(E.Message);
     end;
end;

function ReadPublicKey(AFileName: AnsiString): pEVP_PKEY;
var
   Keyfile: pBIO;
   K: pEVP_PKEY;
begin
     try
        K := Nil;
        KeyFile := BIO_new(BIO_s_file());
        BIO_read_filename(KeyFile, PAnsiChar(AFilename));
        Result := PEM_read_bio_PUBKEY(KeyFile, K, Nil, Nil);
        BIO_free(KeyFile);
     except
        ON E:Exception DO
           ShowMessage(E.Message);
     end;
end;

function RSASignString(PubKeyFile:AnsiString): String;
const
     BIO_FLAGS_BASE64_NO_NL = $100;
var
   Key: pEVP_PKEY;
   InBuf, OutBuf, OutBuf64: Array[0..2047] of AnsiChar;
   B64, BMem: pBIO;
   Rsa: pRSA;
   cleartext: pBIO;
   keysize: Integer;
   rsa_in, rsa_out: Pointer;
   rsa_inlen: Integer;
begin
     try
        Result := '';
        SecretKey:=GenerateRandomKey;

        libeay32.OpenSSL_add_all_algorithms; //
        libeay32.OpenSSL_add_all_ciphers; // InitOpenSSL
        libeay32.OpenSSL_add_all_digests; //
        ERR_load_crypto_strings; //

        Key := ReadPublicKey(PubKeyFile);

        if Key <> Nil
           then begin
                     Rsa := EVP_PKEY_get1_RSA(Key);
                     EVP_PKEY_free(Key);

                     FillChar(InBuf[0], 2048, #0);
                     FillChar(OutBuf[0], 2048, #0);
                     FillChar(OutBuf64[0], 2048, #0);

                     StrPCopy(InBuf, AnsiString(SecretKey));

                     cleartext := BIO_new_mem_buf(@InBuf, Length(SecretKey));
                     BIO_write(cleartext, @InBuf, Length(SecretKey));

                     keysize := RSA_size(Rsa);

                     // Should be free if exception is raised
                     rsa_in := OPENSSL_malloc(keysize * 2);
                     rsa_out := OPENSSL_malloc(keysize);

                     // Read the input data
                     rsa_inlen := BIO_read(cleartext, rsa_in, keysize * 2);
                     RSA_public_encrypt(rsa_inlen, @InBuf, @OutBuf, Rsa, RSA_PKCS1_PADDING);

                     RSA_free(rsa);
                     BIO_free(cleartext);
                     if rsa_in <> nil
                        then OPENSSL_free(rsa_in);
                     if rsa_out <> nil
                        then OPENSSL_free(rsa_out);

                     // Converter para base64
                     B64 := BIO_new(BIO_f_base64());
                     BIO_set_flags(B64, BIO_FLAGS_BASE64_NO_NL);
                     BMem := BIO_new(BIO_s_mem());
                     B64 := BIO_push(B64, BMem);
                     BIO_write(B64, @OutBuf, KeySize);
                     BIO_flush(B64);
                     BIO_read(BMem, @OutBuf64, 2048);
                     BIO_free_all(B64);

                     Result := String(StrPas(OutBuf64));
                end
           else Result := 'Erro';
     except
        ON E:Exception DO
           ShowMessage(E.Message);
     end;
end;

procedure THTTPEvents.HTTPReqResp1BeforePost(const HTTPReqResp: THTTPReqResp; Data: Pointer);
var
   Store        : IStore;
   Cert         : ICertificate2;
   CertContext  : ICertContext;
   PCertContext : PCCERT_CONTEXT;
begin
     try
        if not FileExists(HTTPEvents.PFXFile)
           then Raise Exception.Create('Ficheiro de certificado não encontrado!');

        HttpReqResp.ConnectTimeout:=12000;
        HttpReqResp.ReceiveTimeout:=12000;
        HttpReqResp.SendTimeout:=12000;

        // create Certificate store object
        Store:=CoStore.Create;
        Cert := CoCertificate.Create;
        Cert.Load(HTTPEvents.PFXFile,HTTPEvents.PFXPass,CAPICOM_KEY_STORAGE_DEFAULT,CAPICOM_CURRENT_USER_KEY);

        CertContext:=Cert as ICertContext;
        CertContext.Get_CertContext(Integer(PCertContext));

        // set the certificate to use for the SSL connection
        if not InternetSetOption(Data,INTERNET_OPTION_CLIENT_CERT_CONTEXT,PCertContext,Sizeof(CERTCONTEXT)*5)
           then Raise Exception.Create('Problema no certificado!');
        CertContext.FreeContext( Integer( PCertContext ) );
     except
        ON E:Exception DO
           ShowMessage(E.Message);
     end;
end;

function ZNow:String; Export;
var
   myxsDT: TXSDatetime;
   IdSNTP: TIdSNTP;
   ServerTZID: String;
   TZ: TTimeZone;
begin
     try
        Result := '';

        IdSNTP := TIdSNTP.Create(Nil);
        IdSNTP.ReceiveTimeout := 3000;

        // 1. retrieve server timezone info
        ServerTZID := 'Portugal'; // MyServer.GetTimezoneInfo; e.g. 'Pacific Standard Time';
        // look up the retrieved timezone
        TZ := TBundledTimeZone.GetTimeZone(ServerTZID); // nil if not found

        myxsDT := TXSDatetime.Create;
        try
           try
              IdSNTP.Host := 'ntp04.oal.ul.pt';
              myxsDT.AsUTCDateTime := TZ.ToUniversalTime(IdSNTP.DateTime);
              if myxsDT.Year  = 1899
                 then begin
                           IdSNTP.Active := False;
                           IdSNTP.Host := 'ntp02.oal.ul.pt';
                           myxsDT.AsUTCDateTime := TZ.ToUniversalTime(IdSNTP.DateTime);
                           if myxsDT.Year  = 1899
                              then myxsDT.AsUTCDateTime := TZ.ToUniversalTime(Now);
                      end;
           except
              try
                 myxsDT.AsUTCDateTime := TZ.ToUniversalTime(Now);
              except
              end;
           end;
        finally
           Result := myxsDT.NativeToXS;
           myxsDT.Free;
           IdSNTP.Active := False;
           IdSNTP.Free;
        end;
     except
        ON E:Exception DO
           ShowMessage(E.Message);
     end;
end;

Function CheckUrl(url:string):Boolean; Export;
var
    hSession, hfile: hInternet;
    dwindex,dwcodelen:dword;
    dwcode:array[1..20] of char;
    res : pchar;
begin
     try
        Result := false;
        hSession := InternetOpen('InetURL:/1.0',INTERNET_OPEN_TYPE_PRECONFIG,nil, nil, 0);
        if assigned(hsession)
           then begin
                     hfile:=InternetOpenUrl(hsession,pchar(url),nil,0,INTERNET_FLAG_RELOAD,0);
                     dwIndex:=0;
                     dwCodeLen:=10;
                     HttpQueryInfo(hfile, HTTP_QUERY_STATUS_CODE,@dwcode, dwcodeLen, dwIndex);
                     res := pchar(@dwcode);
                     result:=(res='200') or (res='302');
                     if assigned(hfile)
                        then InternetCloseHandle(hfile);
                     InternetCloseHandle(hsession);
                end;
     except
        ON E:Exception DO
           ShowMessage(E.Message);
     end;
end;

function _ValidaTDoc(XMLData,PubKeyFile,PFXFile,PFXPass:WideString):WideString; StdCall;
var
   Stream: TMemoryStream;
   StrStream: TStringStream;
   HTTPReqResp:THTTPReqResp;
   XML:IXMLDOCUMENT;
   CurNode:IXMLNODE;
begin
     try
        HTTPEvents:=THTTPEvents.Create;
        HTTPEvents.PFXFile:=String(PFXFile);
        HTTPEvents.PFXPass:=String(PFXPass);

        XML := NewXMLDocument;
        XML.Encoding:='utf-8';
        XML.StandAlone:='no';
        XML.Options:=[doNodeAutoIndent];
        XML.LoadFromXML(String(XMLData));

        with XML.DocumentElement.ChildNodes[0].ChildNodes[0].ChildNodes[0].ChildNodes do
             begin
                  // Nonce
                  CurNode:=FindNode('Nonce');
                  if Assigned(CurNode)
                     then CurNode.Text:=RSASignString(String(PubKeyFile));

                  // Password
                  CurNode:=FindNode('Password');
                  if Assigned(CurNode)
                     then CurNode.Text:=AESEncString(String(CurNode.Text));

                  // Created
                  CurNode:=FindNode('Created');
                  if Assigned(CurNode)
                     then CurNode.Text:=AESEncString(ZNow);
             end;

        HTTPReqResp:=THTTPReqResp.Create(nil);
        try
           Result:='';

           // Se não conseguir pingar o URL de webservices, desiste
           if not CheckURL(cATUrl)
              then Exit;
           Stream := TMemoryStream.Create;
           try
              HTTPReqResp.OnBeforePost:=HTTPEvents.HTTPReqResp1BeforePost;
              HTTPReqResp.URL := cSoapUrl;
              HTTPReqResp.UseUTF8InHeader := True;
              HTTPReqResp.SoapAction := cSoapAction;
              HTTPReqResp.Execute(XML.XML.Text, Stream);
              StrStream := TStringStream.Create('');
              try
                 StrStream.CopyFrom(Stream, 0);
                 Result:=WideString(StrStream.DataString);
              finally
                 StrStream.Free;
              end;
           finally
              Stream.Free;
           end;
        finally
           HTTPReqResp.Free;
        end;
        HTTPEvents.Free;
     except
        ON E:Exception DO
           ShowMessage(E.Message);
     end;
end;

function ValidaTDoc(XMLData,PubKeyFile,PFXFile,PFXPass:WideString):WideString; StdCall; Export;
begin
     // Inicializa a aplicação COM
     CoInitialize(nil); // Devia ser aplicação a fazer mas nao ha garantia que o faça
     try
        //O codigo tem de passar para outra função senão ha erros no CoUninitialize
        result := _ValidaTDoc(XMLData,PubKeyFile,PFXFile,PFXPass);
     finally
        // Desinicializa a aplicação COM
        CoUninitialize;
     end;
end;

Exports
       CheckURL,
       ZNow,
       ValidaTDoc,
       InitWS,
       EchoURL;

begin
end.

