unit unit6;

// Свободный конвертер
// КонтинентСвободы.рф
// Лицензия GNU GPL v3


{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, dom, xmlwrite, gettext, ExtCtrls;

type

  { TfrmExport }

  TfrmExport = class(TForm)
    cancelbtn: TButton;
    exportbtn: TButton;
    Label1: TLabel;
    ListBox1: TListBox;
    Panel1: TPanel;
    savedialog1: TSavedialog;
    procedure cancelbtnClick(Sender: TObject);
    procedure exportbtnClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  frmExport: TfrmExport;

implementation

uses unit1;

{ TfrmExport }

procedure TfrmExport.FormShow(Sender: TObject);
var
i:integer;
node,subnode: tdomnode;
begin

   for i:= 0 to presets.ChildNodes.Count -1  do
   begin
    node:= presets.ChildNodes.item[i];
    subnode:= node.FindNode('label');
    listbox1.items.add(subnode.findnode('#text').NodeValue);
   end;
end;

procedure TfrmExport.FormResize(Sender: TObject);
begin
  exportbtn.Top:=frmExport.Height-40;
  exportbtn.Left:=frmExport.Width-179;
  cancelbtn.Top:=frmExport.Height-40;
  cancelbtn.Left:=frmExport.Width-91;
  listbox1.Width:=frmExport.Width-37;
  listbox1.Height:=frmExport.Height-88;
end;

procedure TfrmExport.cancelbtnClick(Sender: TObject);
begin
  frmExport.close;
end;

procedure TfrmExport.exportbtnClick(Sender: TObject);
var
exportfile: txmldocument;
exportpreset: tdomelement;
node,subnode,newnode: tdomnode;
exlabel,exparams,exext,excat: string;
i,j:integer;
pn,selectedtext:string;
begin

exportfile := txmldocument.Create;
exportpreset:= exportfile.CreateElement('presets');
exportfile.AppendChild(exportpreset);

for i := 0 to listbox1.Count-1 do
  begin

   if listbox1.Selected[i] then
     begin

      selectedtext:= listbox1.Items[i];
      for j:= 0 to presets.childnodes.count -1 do  // find the preset name
        begin
          node := presets.childnodes.item[j];
          subnode:= node.FindNode('label');
          if selectedtext = subnode.findnode('#text').nodevalue then
          pn := node.nodename;
        end;

      if pn = '' then
       begin
         showmessage(rsPresettoExport);
         exit;
       end;

      exlabel := presets.FindNode(pn).FindNode('label').FindNode('#text').NodeValue;
      exparams := presets.FindNode(pn).FindNode('params').FindNode('#text').NodeValue;
      exext := presets.FindNode(pn).FindNode('extension').FindNode('#text').NodeValue;
      excat := presets.FindNode(pn).FindNode('category').FindNode('#text').NodeValue;

      newnode := exportfile.CreateElement(pn);
      exportpreset.AppendChild(newnode);

      newnode := exportfile.CreateElement('label');
      exportpreset.FindNode(pn).AppendChild(newnode);
      newnode := exportfile.CreateElement('params');
      exportpreset.FindNode(pn).AppendChild(newnode);
      newnode := exportfile.CreateElement('extension');
      exportpreset.FindNode(pn).AppendChild(newnode);
      newnode := exportfile.CreateElement('category');
      exportpreset.FindNode(pn).AppendChild(newnode);

      newnode := exportfile.CreateTextNode(exlabel);
      exportpreset.FindNode(pn).FindNode('label').AppendChild(newnode);
      newnode := exportfile.CreateTextNode(exparams);
      exportpreset.FindNode(pn).FindNode('params').AppendChild(newnode);
      newnode := exportfile.CreateTextNode(exext);
      exportpreset.FindNode(pn).FindNode('extension').AppendChild(newnode);
      newnode := exportfile.CreateTextNode(excat);
      exportpreset.FindNode(pn).FindNode('category').AppendChild(newnode);

     end;

   end;

  savedialog1.FileName:=pn + '.wff';
  if not savedialog1.Execute then
      exit;

  writexmlfile(exportfile,savedialog1.FileName);

  frmExport.close;

end;

initialization
  {$I unit6.lrs}

end.

