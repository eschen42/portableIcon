@echo off
setlocal
set ARGS=
set ICONT_ARGS=
set ARG0=%~dps0
set ARG=%1
set ICN_FILE=
if not defined ARG goto usage_ERROR

:: shift till last arg is %1
set ARG=%1
:more_args
  if /I ""%ARG%"" == ""--help"" goto usage
  if    ""%ARG%"" == ""/?""     goto usage
  if /I ""%ARG%"" == ""-H""     goto usage
  set ARG2=%2
  if defined ICN_FILE goto next_arg
    set ICONT_ARGS=%ARGS%
    set ARGS=
    if exist %~dpns1.icn set ICN_FILE=%~dpns1.icn& set ARG1=%1& set ARG1dpnsx=%~dpnsx1& set ARG1dps=%~dps1& set ARG1ns=%~ns1&
    if "%~ns1" == "-" set ICN_FILE=-& set ARG1ns=%~ns1
  :next_arg
  shift
  set ARG=%1
  set ARGS=%ARGS% %ARG%
  if not defined ARG2 goto got_args
  goto more_args
:got_args

set EXIT_ERROR=0
if not "%ICN_FILE%" == "-" set ARG1bat=%ARG1dps%%ARG1ns%.bat& set ARG1exe=%ARG1dps%%ARG1ns%.exe& goto not_pipe
if "%ICN_FILE%" == "-" set ARG1bat=%ARG1dps%pipe%RANDOM%.bat& set ARG1exe=%ARG1dps%pipe%RANDOM%.exe& goto have_pipe

:not_pipe
  if not exist %ARG1dpnsx% if not exist %ARG1dpnsx%.icn goto usage_ERROR
  if /I not "%ARG1dpnsx:~-4%" == ".icn" set ARG1dpnsx=%ARG1dpnsx%.icn 
  if not exist %ARG1dpnsx% goto usage_ERROR
  cmd /c ^"type %ARG1dpnsx% ^| call %ARG0%icont.cmd -o %ARG1exe% -u -v0 %ICONT_ARGS% - ^& if exist %ARG1exe% ( %ARG0%bin\iconx.exe %ARG1exe% %ARGS% ^& del %ARG1exe% ) else (echo translation FAILED) ^"
  goto post_pipe

:have_pipe
cmd /c ^"call %ARG0%icont.cmd -o %ARG1exe% -u -v0 - ^& if exist %ARG1exe% ( %ARG0%bin\iconx.exe %ARG1exe% %ARGS% ^& del %ARG1exe% ) else (echo translation FAILED) ^"

:post_pipe
set EXIT_ERROR=%ERRORLEVEL%
if %EXIT_ERROR% == 0 exit /b 0
echo exit code %EXIT_ERROR% 1>&2
endlocal&exit /b %EXIT_ERROR%

:usage_ERROR
set EXIT_ERROR=1

:usage
echo usage: icon [program.icn or -] [args]
endlocal&exit /b %EXIT_ERROR%


