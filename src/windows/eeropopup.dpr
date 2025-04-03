program eeropopup;

uses
  Forms,
  eeropopup1 in 'eeropopup1.pas' {eeroBypassClient},
  CoolTrayIcon in '..\..\vcl\CoolTrayIcon\CoolTrayIcon.pas',
  SimpleTimer in '..\..\vcl\CoolTrayIcon\SimpleTimer.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TeeroBypassClient, eeroBypassClient);
  Application.Run;
end.
