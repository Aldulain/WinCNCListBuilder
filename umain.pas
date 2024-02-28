unit uMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, BCButton;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    btnAddFile: TBCButton;
    btnRemoveFile: TBCButton;
    btnLoadList: TBCButton;
    btnSaveList: TBCButton;
    btnHelp: TBCButton;
    imLogo: TImage;
    lbTapFiles: TListBox;
    pnlButtonBar: TPanel;
    pnlListContainer: TPanel;
    procedure btnAddFileClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure btnLoadListClick(Sender: TObject);
    procedure btnRemoveFileClick(Sender: TObject);
    procedure btnSaveListClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure lbTapFilesDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure lbTapFilesDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure lbTapFilesMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    fDraggedStartPos : TPoint;
  public

  end;

var
  frmMain: TfrmMain;

implementation

{$R *.lfm}

{ TfrmMain }

uses
  {windirs,} uHelp;

procedure TfrmMain.lbTapFilesMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  fDraggedStartPos := Point(X, Y);
end;

procedure TfrmMain.lbTapFilesDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  listBox : TListBox;
  startIdx, targetIdx : Integer;
begin
  Assert(Source = Sender);

  listBox := Sender as TListBox;
  startIdx := listBox.ItemAtPos(fDraggedStartPos, true);
  targetIdx := listBox.ItemAtPos(Point(X, Y), True);

  if startIdx = -1 then
  begin
    listBox.Cursor := crDefault;
    exit;
  end;
  if targetIdx = -1 then targetIdx := listBox.Count - 1;
  listBox.Items.Move(startIdx, targetIdx);

  listBox.Cursor := crDefault;
end;

procedure TfrmMain.btnAddFileClick(Sender: TObject);
var
  opnDialog : TOpenDialog;
  i : Integer;
begin
  opnDialog := TOpenDialog.Create(nil);
  try
    opnDialog.Options := [ofAllowMultiSelect];
    opnDialog.DefaultExt := '.tap';
    opnDialog.Filter := 'WTM Gcode File | *.tap';

    if opnDialog.Execute then
    begin
      for i := 0 to opnDialog.Files.Count - 1 do
      begin
        lbTapFiles.Items.Append(opnDialog.Files[i]);
      end;
    end;
  finally
    opnDialog.Free;
  end;
end;

procedure TfrmMain.btnHelpClick(Sender: TObject);
begin
  frmHelp.Show;
end;

procedure TfrmMain.btnLoadListClick(Sender: TObject);
var
  opnDialog : TOpenDialog;
  tfContent : TStringList;
  i : Integer;
begin
  opnDialog := TOpenDialog.Create(nil);
  tfContent := TStringList.Create;
  try
    opnDialog.DefaultExt := '.LST';
    opnDialog.Filter := 'WinCnC List File | *.LST';

    if opnDialog.Execute then
    begin
      tfContent.LoadFromFile(opnDialog.FileName);
      for i := 0 to tfContent.Count - 1 do
      begin
        lbTapFiles.Items.Append(tfContent.Strings[i]);
      end;
    end;
  finally
    tfContent.Free;
    opnDialog.Free;
  end;
end;

procedure TfrmMain.btnRemoveFileClick(Sender: TObject);
var
  i : Integer;
begin
  if lbTapFiles.SelCount = 0 then
    ShowMessage('Select files to remove from the list.')
  else
  begin
    for i := lbTapFiles.Count - 1 downto 0 do
    begin
      if lbTapFiles.Selected[i] then
      begin
        lbTapFiles.Items.Delete(i);
      end;
    end;
  end;
end;

procedure TfrmMain.btnSaveListClick(Sender: TObject);
var
  saveDialog : TSaveDialog;
  tfContent : TStringList;
  i : Integer;
begin
  saveDialog := TSaveDialog.Create(nil);
  try
    saveDialog.DefaultExt := '.LST';
    saveDialog.Filter := 'WinCnC List File | *.LST';

    if saveDialog.Execute then
    begin
      tfContent := TStringList.Create;
      try
        for i := 0 to lbTapFiles.Count - 1 do
        begin
          tfContent.Append(lbTapFiles.Items[i]);
        end;

        tfContent.SaveToFile(saveDialog.FileName);
      finally
        tfContent.Free;
      end;
    end;
  finally
    saveDialog.Free;
  end;
end;

procedure TfrmMain.FormResize(Sender: TObject);
begin
  if Self.Width < 576 then
    Self.Width := 576;
end;

procedure TfrmMain.lbTapFilesDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := Source = lbTapFiles;
  lbTapFiles.Cursor := crDrag;
end;

end.

