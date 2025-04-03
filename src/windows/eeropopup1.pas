unit eeropopup1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdBaseComponent, IdComponent, IdUDPBase, IdUDPServer, Menus,
  ImgList, CoolTrayIcon,mmsystem, StdCtrls,IdSocketHandle, AppEvnts;

type
  TeeroBypassClient = class(TForm)
    IdUDPServer1: TIdUDPServer;
    CoolTrayIcon1: TCoolTrayIcon;
    ImageList1: TImageList;
    PopupMenu1: TPopupMenu;
    Markasread1: TMenuItem;
    CurrentStatus1: TMenuItem;
    StopClient1: TMenuItem;
    Memo1: TMemo;
    ApplicationEvents1: TApplicationEvents;
    ShowLog1: TMenuItem;
    procedure IdUDPServer1UDPRead(Sender: TObject; AData: TStream;
      ABinding: TIdSocketHandle);
    procedure CoolTrayIcon1Startup(Sender: TObject;
      var ShowMainForm: Boolean);
    procedure Markasread1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure StopClient1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ApplicationEvents1Exception(Sender: TObject; E: Exception);
    procedure ShowLog1Click(Sender: TObject);
  private
    { Private declarations }
  public
  config:tstringlist;
  reconnects:DWORD;
  function BatExecute(const params:String):hinst;
    { Public declarations }
  end;

var
  eeroBypassClient: TeeroBypassClient;

implementation

{$R *.dfm}
function teerobypassclient.BatExecute;
var cmdline:array[0..512]of char;
sParams:String;
begin
result:=error_file_not_found;
if not fileexists(changefileext(config[0],'.bat'))then exit;
sparams:=stringreplace(params,#13,emptystr,[rfreplaceall]);
sparams:=stringreplace(sparams,#10,emptystr,[rfreplaceall]);
result:=winexec(Strfmt(CmdLine,'%s %s',[changefileext(config[0],'.bat'),sparams])
,sw_hide);
end;
procedure TeeroBypassClient.IdUDPServer1UDPRead(Sender: TObject;
  AData: TStream; ABinding: TIdSocketHandle);
var Opcode:pansichar;
minutes,minutesErr:integer;
waveid:byte;
timeStr:string;
begin
timestr:=TimeTostr(Time);
opcode:=allocmem(adata.Size+1);
adata.Position:=0;
adata.Read(opcode^,adata.Size);
cooltrayicon1.cycleIcons:=(pos('EERO_DISCONNECT',opcode)=1)or(pos('EERO_RECONNECT',
opcode)=1)or(pos('EERO_HELLO',opcode)=1)or(Pos('EERO_TIMER',opcode)=1);
if not cooltrayicon1.CycleIcons then exit;
if pos('EERO_DISCONNECT',opcode)=1then begin
waveid:=1;
currentstatus1.Caption:=timestr+' - eero Router has disconnected'end else
if pos('EERO_RECONNECT',opcode)=1then begin
currentstatus1.Caption:=timestr+' - eero Router has Reconnected';
waveid:=2;
end else if pos('EERO_HELLO',opcode)=1then begin
currentstatus1.Caption:=timestr+' - eeroBypass server has started';
waveid:=3;
end else if pos('EERO_TIMER',Opcode)=1then begin
val(copy(strpas(OpCode),length('EERO_TIMERx'),MaxInt),minutes,minutesErr);
currentstatus1.Caption:=timestr+' - Internet will be lost in '+inttostr(minutes)+
' minute(s)';waveid:=4;
end else begin
currentstatus1.Caption:=timestr+ ' - "'+opcode+'" is not a valid client opcode';
freemem(opcode,adata.size+1);
exit;
end;
batexecute(opcode);
if(config.IndexOf('beep')>0)then
windows.Beep(1024,512);
if config.IndexOf('NoSound')<0then if not playsound('eeroDefault.wav',0,
snd_filename or snd_Async or snd_nowait or snd_nodefault)then if(not playsound(
pchar('eero'+inttostr(waveid)+'.wav'),0,SND_FILENAME or SND_ASYNC or SND_NOWAIT
 or SND_NODEFAULT))and(pos(' - Failed to play sound file!',memo1.Text)=0)then
memo1.Lines.Insert(0,timestr+' - Failed to play sound file!');
cooltrayicon1.ShowBalloonHint('eeroBypass',currentstatus1.Caption,bitInfo,60);
memo1.Lines.Insert(0,currentstatus1.Caption);
freemem(opcode,adata.size+1);
end;

procedure TeeroBypassClient.CoolTrayIcon1Startup(Sender: TObject;
  var ShowMainForm: Boolean);
begin  
config:=tstringlist.Create;
config.Delimiter:=#32;
config.DelimitedText:=getcommandline;
showmainform:=(Config.IndexOf('/?')>0);
end;

procedure TeeroBypassClient.Markasread1Click(Sender: TObject);
begin
cooltrayicon1.CycleIcons:=false;
cooltrayicon1.IconIndex:=0;
end;

procedure TeeroBypassClient.FormCreate(Sender: TObject);
var hkRun:HKEY;
begin
memo1.Lines.Text:=format(memo1.Lines.Text,[ExtractFilename(config[0])]);
if config.IndexOf('/?')>0then exit;
memo1.Lines.Text:=datetimetostr(now)+' - eeroBypass client started';
idudpserver1.DefaultPort:=strtointdef(config.Values['port'],
idudpserver1.DefaultPort);
idudpserver1.Active:=true;
regcreatekeyex(HKEY_CURRENT_USER,'SOFTWARE\Microsoft\Windows\CurrentVersion\Run',
0,nil,REG_OPTION_NON_VOLATILE,KEY_ALL_ACCESS,nil,hkrun,nil);
if config.IndexOf('autorun')>0then regsetvalueex(hkrun,'eeroBypass Client',0,
reg_sz,getcommandline,(1+strlen(GetCommandline))*Sizeof(Char));
if config.IndexOf('noautorun')>0then regdeletevalue(hkrun,'eeroBypass Client');
regclosekey(hkrun);
cooltrayicon1.IconVisible:=true;
end;

procedure TeeroBypassClient.StopClient1Click(Sender: TObject);
begin
close;
end;

procedure TeeroBypassClient.FormDestroy(Sender: TObject);
begin
config.Free;
exitprocess(0);
end;

procedure TeeroBypassClient.ApplicationEvents1Exception(Sender: TObject;
  E: Exception);
begin
memo1.Lines.Insert(0,Timetostr(time)+' - '+e.ClassName+': '+e.Message);
end;

procedure TeeroBypassClient.ShowLog1Click(Sender: TObject);
begin
show;
end;

end.
