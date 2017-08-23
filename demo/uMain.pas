(******************************************************************************)
(** Suite         : AtWS                                                     **)
(** Object        : TfMain                                                   **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(******************************************************************************)
(** Dependencies  : AtWS                                                     **)
(******************************************************************************)
(** Description   : Demo project for AtWS.dll                                **)
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

unit uMain;

interface

uses
    Classes
  , Controls
  , Forms
  , StdCtrls
  , AtWSvcIntf
  ;

type
  TfMain = class(TForm)
    Memo1: TMemo;
    bSetupProductionWS: TButton;
    bSetupTestingWS: TButton;
    Memo2: TMemo;
    bSendDoc: TButton;
    procedure bSetupProductionWSClick(Sender: TObject);
    procedure bSetupTestingWSClick(Sender: TObject);
    procedure bSendDocClick(Sender: TObject);
  private
    FAtWS: IAtWSvc;
  public
    { Public declarations }
  end;

var
  fMain: TfMain;

function ATWebService(const SoapURL, SoapAction, PubKeyFile, PFXFile, PFXPass: WideString): IAtWSvc; stdcall; external 'AtWS.dll';

implementation

uses
    Dialogs
  , XMLDoc
  , SysUtils
  ;

{$R *.dfm}

procedure TfMain.bSetupTestingWSClick(Sender: TObject);
begin
  FAtWS := ATWebService(
    'https://servicos.portaldasfinancas.gov.pt:701/sgdtws/documentosTransporte',
    'https://servicos.portaldasfinancas.gov.pt/sgdtws/documentosTransporte/',
    'ChavePublicaAT.pem',
    'TESTEWebServices.pfx',
    'TESTEwebservice'
  );
  bSendDoc.Caption := 'Enviar documento de Teste';
  bSendDoc.Enabled := True;
end;

procedure TfMain.bSendDocClick(Sender: TObject);
begin
  if not Assigned(FAtWS)
    then raise Exception.Create('Webservice not initialized.');
  Memo2.Text := FormatXMLData(
    FAtWS.Send(
      Memo1.Text
    )
  );
end;

procedure TfMain.bSetupProductionWSClick(Sender: TObject);
begin
  FAtWS := ATWebService(
    'https://servicos.portaldasfinancas.gov.pt:401/sgdtws/documentosTransporte',
    'https://servicos.portaldasfinancas.gov.pt/sgdtws/documentosTransporte/',
    'ChavePublicaAT.pem',
    '555555550.pfx',
    'XPTO'
  );
  bSendDoc.Caption := 'Enviar documento de Produção';
  bSendDoc.Enabled := True;
end;

end.
