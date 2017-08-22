unit uMainTestesDLLs;

interface

uses
  WinAPI.Windows, WinAPI.Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, XMLDoc;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Button2: TButton;
    Button1: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

procedure InitWS(SoapURL,SoapAction:WideString); StdCall; External 'ATWSDocTransp.dll';
function ValidaTDoc(XMLData,PubKeyFile,PFXFile,PFXPass:WideString):WideString; StdCall; External 'ATWSDocTransp.dll';

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
     ShowMessage('Servidor de Testes (701)');
     InitWS('https://servicos.portaldasfinancas.gov.pt:701/sgdtws/documentosTransporte','https://servicos.portaldasfinancas.gov.pt/sgdtws/documentosTransporte/');
     memo1.Text:=FormatXMLData(ValidaTDoc(PChar(memo1.Text),'ChavePublicaAT.pem','TESTESWebServices.pfx','TESTEwebservice'));
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
     ShowMessage('Servidor de Produção (401)');
     InitWS('https://servicos.portaldasfinancas.gov.pt:401/sgdtws/documentosTransporte','https://servicos.portaldasfinancas.gov.pt/sgdtws/documentosTransporte/');
     memo1.Text:=FormatXMLData(ValidaTDoc(PChar(memo1.Text),'ChavePublicaAT.pem','555555550.pfx','XPTO'));
end;

end.
