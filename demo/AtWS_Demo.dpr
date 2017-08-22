program AtWS_Demo;

uses
  Forms,
  uMain in 'uMain.pas' {fMain},
  AtWSvcIntf in '..\src\AtWSvcIntf.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfMain, fMain);
  Application.Run;
end.
