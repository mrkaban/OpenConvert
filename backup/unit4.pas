unit Unit4;

// Свободный конвертер
// КонтинентСвободы.рф
// Лицензия GNU GPL v3

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, Buttons,
  ExtCtrls, StdCtrls, gettext, translations, ComCtrls;

type

  { TfrmPreferences }

  TfrmPreferences = class(TForm)
    btnCancel: TBitBtn;
    btnOK: TBitBtn;
    btnDefaultDir: TButton;
    btnWinFFmpegPath: TButton;
    btnBeforeCommand: TButton;
    btnWinFFplayPath: TButton;
    btnLinFFmpegPath: TButton;
    btnLinFFplayPath: TButton;
    btnLinTerminalExe: TButton;
    btnAfterCommand: TButton;
    cbEnableMulti: TCheckBox;
    cbRememberLastDir: TCheckBox;
    cbCHCPchar: TCheckBox;
    cbThreads: TCheckBox;
    edtDefaultDir: TEdit;
    edtWinFFmpegPath: TEdit;
    edtBeforeCommand: TEdit;
    edtWinFFplayPath: TEdit;
    edtLinFFmpegPath: TEdit;
    edtLinFFplayPath: TEdit;
    edtLinTerminalExe: TEdit;
    edtLinTerminalOptions: TEdit;
    edtThreads: TEdit;
    edtAfterCommand: TEdit;
    lblDefaultDir: TLabel;
    lblLinTerminalExe: TLabel;
    lblLinTerminalOptions: TLabel;
    lblWinFFmpegPath: TLabel;
    lblBeforeCommand: TLabel;
    lblWinFFplay: TLabel;
    lblLinFFmpegPath: TLabel;
    lblLinFFplayPath: TLabel;
    lblPriority: TLabel;
    lblAfterCommand: TLabel;
    PageControl1: TPageControl;
    OpenDialog1: TOpenDialog;
    pnlLinTerminalOptions: TPanel;
    pnlDefaultDir: TPanel;
    pnlThreads: TPanel;
    pnlPriority: TPanel;
    pnlWinFFmpegPath: TPanel;
    pnlBeforeCommand: TPanel;
    pnlWinFFplayPath: TPanel;
    pnlLinFFmpegPath: TPanel;
    pnlLinFFplayPath: TPanel;
    pnlLinTerminalExe: TPanel;
    pnlBottom: TPanel;
    pnlAfterCommand: TPanel;
    prioritybox: TComboBox;
    sbGeneral: TScrollBox;
    sbWindows: TScrollBox;
    sbLinux: TScrollBox;
    sbScripting: TScrollBox;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    tabGeneral: TTabSheet;
    tabScripting: TTabSheet;
    tabWindows: TTabSheet;
    tabLinux: TTabSheet;
    procedure btnBeforeCommandClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnDefaultDirClick(Sender: TObject);
    procedure btnWinFFmpegPathClick(Sender: TObject);
    procedure btnWinFFplayPathClick(Sender: TObject);
    procedure btnLinFFmpegPathClick(Sender: TObject);
    procedure btnLinFFplayPathClick(Sender: TObject);
    procedure btnLinTerminalExeClick(Sender: TObject);
    procedure edtThreadsChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmPreferences: TfrmPreferences;

resourcestring
    rspriorityhigh='Высокий';
    rsprioritynormal='Нормальный';
    rspriorityidle='Низкий';

implementation

uses unit1;
{ TfrmPreferences }

// load preferences
procedure TfrmPreferences.FormCreate(Sender: TObject);

begin
    TranslateUnitResourceStrings('unit4', PODirectory + 'winff.%s.po', unit1.Lang, unit1.FallbackLang);
    prioritybox.Clear ;
    prioritybox.Items.Add(rspriorityhigh);
    prioritybox.Items.Add(rsprioritynormal);
    prioritybox.Items.Add(rspriorityidle);
  {$ifdef windows}
   edtWinFFmpegPath.Text:= frmMain.getconfigvalue('win32/ffmpeg');
   edtWinFFplayPath.Text:= frmMain.getconfigvalue('win32/ffplay');
   if frmMain.getconfigvalue('win32/chcp') = 'true' then
     cbCHCPchar.Checked := true
  else
     cbCHCPchar.Checked := false;
  {$endif}
  {$ifdef unix}

   edtLinFFmpegPath.Text:= frmMain.getconfigvalue('unix/ffmpeg');
   edtLinFFplayPath.Text:= frmMain.getconfigvalue('unix/ffplay');
   edtLinTerminalExe.Text:= frmMain.getconfigvalue('unix/terminal');
   edtLinTerminalOptions.Text:= frmMain.getconfigvalue('unix/termoptions');
  {$endif}

  edtDefaultDir.Text:= frmMain.getconfigvalue('general/destfolder');


  if frmMain.getconfigvalue('general/rememberlast') = 'true' then
     cbRememberLastDir.Checked := true
  else
     cbRememberLastDir.Checked := false;

  if frmMain.getconfigvalue('general/multithreading') = 'true' then
     cbThreads.Checked := true
  else
     cbThreads.Checked := false;
  edtthreads.Text:= frmMain.getconfigvalue('general/numberofthreads');

  prioritybox.Text := frmMain.getconfigvalue('general/priority');

  if frmMain.getconfigvalue('general/multipresets') = 'true' then
     cbEnableMulti.Checked := true
  else
     cbEnableMulti.Checked := false;

  edtBeforeCommand.Text:= frmMain.getconfigvalue('general/beforecommand');
  edtAfterCommand.Text:= frmMain.getconfigvalue('general/aftercommand');

end;

// save preference
procedure TfrmPreferences.btnOKClick(Sender: TObject);

begin
  frmMain.setconfigvalue('general/destfolder',edtDefaultDir.text);
  frmMain.DestFolder.Text := edtDefaultDir.text;

  if cbRememberLastDir.Checked then
   begin
    frmMain.setconfigvalue('general/rememberlast','true');
    unit1.rememberlast:='true';
   end
  else
   begin
    frmMain.setconfigvalue('general/rememberlast','false');
    unit1.rememberlast:='false';
   end;

  if cbThreads.Checked then
   begin
    frmMain.setconfigvalue('general/multithreading','true');
    unit1.multithreading:='true';
   end
  else
   begin
    frmMain.setconfigvalue('general/multithreading','false');
    unit1.multithreading:='false';
   end;
  edtthreads.Text:=trim(edtthreads.Text);
  frmMain.setconfigvalue('general/numberofthreads', edtthreads.Text);

  frmMain.setconfigvalue('general/priority', prioritybox.Text);

  if cbEnableMulti.Checked then
   begin
    frmMain.setconfigvalue('general/multipresets','true');
    unit1.multipresets:=true;
   end
  else
   begin
    frmMain.setconfigvalue('general/multipresets','false');
    unit1.multipresets:=false;
   end;

  edtDefaultDir.Text := trim(edtDefaultDir.Text);
  edtBeforeCommand.Text := trim(edtBeforeCommand.Text);
  edtAfterCommand.Text := trim(edtAfterCommand.Text);
  edtWinFFmpegPath.Text := trim(edtWinFFmpegPath.Text);
  edtWinFFplayPath.Text := trim(edtWinFFplayPath.Text);
  edtLinFFmpegPath.Text := trim(edtLinFFmpegPath.Text);
  edtLinFFplayPath.Text := trim(edtLinFFplayPath.Text);
  edtLinTerminalExe.Text := trim(edtLinTerminalExe.Text);
  edtLinTerminalOptions.Text := trim(edtLinTerminalOptions.Text);


  frmMain.setconfigvalue('general/beforecommand',edtBeforeCommand.text);
  frmMain.setconfigvalue('general/aftercommand',edtAfterCommand.text);
  unit1.BeforeCommand := edtBeforeCommand.text;
  unit1.AfterCommand := edtAfterCommand.text;

  {$ifdef windows}
  if edtWinFFmpegPath.Text ='' then
   edtWinFFmpegPath.Text := unit1.extrasPath + 'ffmpeg.exe';
  if edtWinFFplayPath.Text ='' then
   edtWinFFplayPath.Text := unit1.extrasPath + 'ffplay.exe';

  unit1.ffmpeg := edtWinFFmpegPath.text;
  unit1.ffplay := edtWinFFplayPath.text;
  frmMain.setconfigvalue('win32/ffmpeg',edtWinFFmpegPath.text);
  frmMain.setconfigvalue('win32/ffplay',edtWinFFplayPath.text);

  if cbCHCPchar.Checked then
   begin
    frmMain.setconfigvalue('win32/chcp','true');
    unit1.usechcp:='true';
   end
  else
   begin
    frmMain.setconfigvalue('win32/chcp','false');
    unit1.usechcp:='false';
   end;
  {$endif}

  {$ifdef unix}
  if edtLinFFmpegPath.Text ='' then
   edtLinFFmpegPath.Text := '/usr/bin/ffmpeg';
  if edtLinFFplayPath.Text ='' then
   edtLinFFplayPath.Text := '/usr/bin/ffplay';
  if edtLinTerminalExe.Text ='' then
   edtLinTerminalExe.Text := '/usr/bin/xterm';

  unit1.ffmpeg := edtLinFFmpegPath.text;
  unit1.ffplay := edtLinFFplayPath.text;
  unit1.terminal :=edtLinTerminalExe.text;
  unit1.termoptions := edtLinTerminalOptions.text;
  frmMain.setconfigvalue('unix/ffmpeg',edtLinFFmpegPath.text);
  frmMain.setconfigvalue('unix/ffplay',edtLinFFplayPath.text);
  frmMain.setconfigvalue('unix/terminal',edtLinTerminalExe.text);
  frmMain.setconfigvalue('unix/termoptions',edtLinTerminalOptions.text);
  {$endif}


  frmPreferences.close;

end;

procedure TfrmPreferences.btnBeforeCommandClick(Sender: TObject);
begin
  if opendialog1.Execute then
    edtBeforeCommand.Text := opendialog1.FileName;
end;

procedure TfrmPreferences.btnDefaultDirClick(Sender: TObject);
begin
 if selectdirectorydialog1.Execute then
    edtDefaultDir.Text := selectdirectorydialog1.FileName;
end;

procedure TfrmPreferences.btnCancelClick(Sender: TObject);
begin
  frmPreferences.close;
end;

procedure TfrmPreferences.btnWinFFmpegPathClick(Sender: TObject);
begin
  if opendialog1.Execute then
    edtWinFFmpegPath.Text := opendialog1.FileName;
end;

procedure TfrmPreferences.btnWinFFplayPathClick(Sender: TObject);
begin
   if opendialog1.Execute then
    edtWinFFplayPath.Text := opendialog1.FileName;
end;

procedure TfrmPreferences.btnLinFFmpegPathClick(Sender: TObject);
begin
  if opendialog1.Execute then
    edtLinFFmpegPath.Text := opendialog1.FileName;
end;

procedure TfrmPreferences.btnLinFFplayPathClick(Sender: TObject);
begin
  if opendialog1.Execute then
    edtLinFFplayPath.Text := opendialog1.FileName;
end;

procedure TfrmPreferences.btnLinTerminalExeClick(Sender: TObject);
begin
   if opendialog1.Execute then
    edtLinTerminalExe.Text := opendialog1.FileName;
end;

procedure TfrmPreferences.edtThreadsChange(Sender: TObject);
begin

end;


initialization
  {$I unit4.lrs}

end.

