program WinListBuilder;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, uMain, uHelp
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Title := 'WinCnC List Builder';
  Application.Scaled := True;
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmHelp, frmHelp);
  Application.Run;
end.

