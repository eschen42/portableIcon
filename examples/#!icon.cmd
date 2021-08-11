@echo off
setlocal
set ARGS=
set ARG0=%~dps0
set ARG1dpnsx=%~dpnsx1
shift

:more_args
  set ARG=%1
  if not defined ARG goto got_args
  set ARGS=%ARGS% %ARG%
  shift
goto more_args

:got_args
type %ARG1dpnsx% | call %ARG0%\..\icon.cmd - %ARGS%
