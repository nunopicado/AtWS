# AtWS - Autoridade Tributária WebService


### Sobre Este Ficheiro ###
DLL com as funções de encriptação e envio por webservices de documentos de transporte para o servidor da AT
Programa demonstração de como usar a DLL

#### Testado com o serviço de envio de documentos de transporte, mas é possível que funcione também com outros webservices da Autoridade Tributária


### Change Log: ###

**v2017.8.23**: Actualização de alguns **Reusable Objects**, efectivamente removemendo dependências nos seguintes módulos: **DelphiOnRails**, **SuperObject** e **UIB**

**v2017.08.22**: Remoção da dependência da **CapiCOM**, remoção da dependência da chave pública **ChavePublicaAT.pem**

**v2013.12.11**: Remoção da necessidade de ter o certificado instalado no Windows



### NOTAS: ###

~~Requer instalação da biblioteca da Microsoft CAPICOM 2.0 (http://www.microsoft.com/pt-pt/download/details.aspx?id=25281)~~

A CapiCOM deixou de ser necessária a partir da versão v2017.08.22

~~Requer que o certificado esteja instalado no Windows~~

Não é necessário instalar o certificado no Windows a partir da versão v2013.12.11

### ATENÇÃO: ###

Esta é uma DLL de testes para fins meramente didáticos. Não foi alvo de testes intensivos que seriam necessários para ambiente de produção. Usem por vosso risco.

### Funções: ###
#### ~~ValidadePFX (PFXFile, PFXPass: WideString): WideString;~~
* ~~Retorna a data de expiração do certificado.~~
* ~~Aceita por parâmetro duas strings, em formato UniCode, e retorna uma no mesmo formato.~~
* ~~O primeiro parâmetro é o caminho completo para o ficheiro do certificado (Extensão PFX), o segundo leva a password do certificado.~~
* ~~A Naming Convention é StdCall, standard do Windows.~~

#### ~~InitWS(SoapURL, SoapAction: WideString; TimeOut: Integer);~~
* ~~Inicializa a DLL. Deve ser chamada antes de qualquer envio de documentos (não precisa ser chamada se for apenas para verificar a validade).~~
* ~~Aceita por parâmetro duas strings, em formato UniCode, e um valor inteiro.~~
* ~~O primeiro parâmetro é o URL do serviço AT, o segundo é a SOAP Action a usar, o terceiro é o número de segundos para o Timeout. Normalmente, 10 segundos é suficiente. Em máquinas lentas/net lenta, subir um pouco pode ser necessário.~~
* ~~A Naming Convention é StdCall, standard do Windows.~~

#### ~~ValidaTDoc(XMLData, PFXFile, PFXPass: WideString): WideString;~~
* ~~Envia um documento de transporte para a AT.~~
* ~~Aceita por parâmetro três strings, em formato UniCode.~~
* ~~O primeiro parâmetro é o documento a enviar, em formato XML, de acordo com as indicações da AT. As excepções são os campos Password (que deve ir em texto simples, e não encriptado), e os campos Nonce e Created, que devem ir vazios. A DLL encarrega-se de encriptar a password e criar os campos Nonce e Created.~~
* ~~Os segundo e terceiro parâmetros são os dados do certificado (caminho completo e password).~~
* ~~Retorna uma string, UniCode também, com o XML de resposta da AT, ou uma string vazia caso não haja resposta.~~
* ~~A Naming Convention é StdCall, standard do Windows.~~

#### function ATWebService(const SoapURL, SoapAction, PubKeyFile, PFXFile, PFXPass: WideString): IAtWSvc; 
* Cria um objecto de envio de documentos para a AT por webservice
* Aceita por parâmetro 5 strings, com encoding UniCode
* **SoapURL** é o *URL* do webservice
* **SoapAction** é a *Action* do webservice
* **PubKeyFile** é o caminho do ficheiro **ChavePublicaAT.pem**. Se o caminho for uma string vazia, ou o ficheiro indicado não existir, a dll tentará usar a chave pública embutida
* **PFXFile** é o caminho do ficheiro do certificado PFX a usar
* **PFXPass** é a password do certificado
* Retorna um *interface* **IAtWSvc**, cuja declaração pode ser encontrada no ficheiro **AtWSvcIntf.pas**
* A *Naming Convention* é ***StdCall***, standard do Windows.

### IAtWSvc: ###

O *interface* IAtWSvc possui apenas um método declarado:
```delphi
  IAtWSvc = interface
  ['{5119FAB4-F5BB-458E-99F0-96CF75F58981}']
    function Send(const XMLData: WideString): WideString;
  end;
```

* **Send** aceita por parâmetro uma string com o pedido ao webservice em formato **XML**, e retorna a resposta do webservice, também em formato **XML**.

### Pedido XML: ###

O **XML** de pedido ao webservice deve estar no formato indicado pelo manual de comunicação de documentos da Autoridade Tributária, com as seguintes excepções:
* **Nonce** O campo **Nonce** deverá existir, mas sem conteúdo: `<wss:Nonce></wss:Nonce>`
* **Password** O campo **Password** deverá ir preenchido com a password sem qualquer encriptação. Será o objecto a encriptar essa password com o formato exigido pelo manual de comunicação de documentos da Autoridade Tributária: `<wss:Password>123456789</wss:Password>`
* **Created** O campo **Created** deverá existir, mas sem conteúdo: `<wss:Created></wss:Created>`


### Requisitos: ###

* ~~Para funcionar, é necessário instalar no PC um pacote da Microsoft, chamado CAPICOM v2.0. Este tem também uma dll (capicom.dll) que deve ser registada no Windows (regsvr32 capicom.dll).~~

* ~~É necessário também que, no Internet Explorer (mesmo que este não seja usado) se defina nas opções avançadas o TLS 1.2 como desabilitado.
Por regra, este protocolo já vinha desabilitado, mas no Windows 8.1, ou no Windows 7/8 com o IE 11 instalado, este protocolo é activado. Deve-se desactivar.~~

* É preciso o certificado, de produção ou de testes, atribuído pela AT.

* O ficheiro **ChavePublicaAT.cer** não é necessário, pois a chave pública está *hardcoded* na dll. De qualquer forma, é possível passar-lhe a chave pública, caso a versão *hardcoded* expire e não se deseje recompilar a dll. Para isto, deve ser passado o ficheiro convertido no formato **PEM** (**ChavePublicaAT.pem**).

* Para compilar a dll, existem uma série de dependências necessárias, que para facilitar estão no repositório na pasta src\ThirdParty. Todo o código dentro dessa pasta pertence aos seus respectivos autores.

* Boa parte desse código são objectos reutilizáveis pertencentes ao meu projecto [Reusable Objects](https://github.com/nunopicado/Reusable-Objects)

### AVISO: ###

De notar que esta DLL não foi alvo de testes extensivos, pelo que o seu uso é por conta e risco do utilizador.
Eu uso-a, com algumas alterações para fazer face às minhas necessidades, e nunca me deu problema, mas ainda assim, não posso garantir nada.
