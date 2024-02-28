unit uHelp;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, BCButton;

type

  { TfrmHelp }

  TfrmHelp = class(TForm)
    btnClose: TBCButton;
    memHelp: TMemo;
    pnlBtnBar: TPanel;
    procedure btnCloseClick(Sender: TObject);
  private

  public

  end;

var
  frmHelp: TfrmHelp;

implementation

{$R *.lfm}

{ TfrmHelp }

procedure TfrmHelp.btnCloseClick(Sender: TObject);
begin
  Close;
end;

end.

