@echo off
setlocal
set ARGS=
set ARG0=%~dps0
set ARG1=
set ARG1=%1
set ARG1dpnsx=%~dpnsx1
set ARG1dps=%~dps1
set ARG1ns=%~ns1
set ARG1bat=%ARG1dps%%ARG1ns%.bat
set EXIT_ERROR=0
shift

if defined ARG1 goto arg1
goto usage_ERROR

:arg1
if /I "%ARG1%" == "--help" goto usage
if /I "%ARG1%" == "/?" goto usage
if /I "%ARG1%" == "-H" goto usage
if "%ARG1ns%" == "-" goto more_args
if not exist %ARG1dpnsx% if not exist %ARG1dpnsx%.icn goto usage_ERROR
if /I not "%ARG1dpnsx:~-4%" == ".icn" set ARG1dpnsx=%ARG1dpnsx%.icn 
if not exist %ARG1dpnsx% goto usage_ERROR

:more_args
  set ARG=%1
  if not defined ARG goto got_args
  set ARGS=%ARGS% %ARG%
  shift
goto more_args

:got_args
if not "%ARG1ns%" == "-" cmd /c ^"type %ARG1dpnsx% ^| call %ARG0%icont.cmd -I -o %ARG1bat% -u -v 0 - ^& if exist %ARG1bat% ( %ARG0%nticonx.exe %ARG1bat% %ARGS% ^& del %ARG1bat% ) else (echo translation FAILED) ^"
if "%ARG1ns%" == "-" cmd /c ^"call %ARG0%icont.cmd -I -o %ARG1bat% -u -v 0 - ^& if exist %ARG1bat% ( %ARG0%nticonx.exe %ARG1bat% %ARGS% ^& del %ARG1bat% ) else (echo translation FAILED) ^"

set EXIT_ERROR=%ERRORLEVEL%
if %EXIT_ERROR% == 0 exit /b 0
echo exit code %EXIT_ERROR% 1>&2
endlocal&exit /b %EXIT_ERROR%

:usage_ERROR
set EXIT_ERROR=1

:usage
echo usage: icon [program.icn or -] [args]
endlocal&exit /b %EXIT_ERROR%
