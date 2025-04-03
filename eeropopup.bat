echo %1 | find "EERO_TIMER"
if not errorlevel 1 goto EERO_TIMER
goto %1
goto done
*************************************************************************
*This batch file is a script to execute commands on certain events      *
*************************************************************************
:EERO_HELLO
::On main server start commands here
goto done
:EERO_RECONNECT
::internet reconnected commands here
goto done
:EERO_DISCONNECT
::interbet disconnect commands here
goto done
:EERO_TIMER
::eero timer warnings
goto done
:done
