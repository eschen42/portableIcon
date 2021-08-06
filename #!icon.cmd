@setlocal&set ICNFILE=%~dpnsx1.icn
@copy %~dpnsx1 %ICNFILE% >NUL
@set ICON=%~dps0icon.cmd&shift&shift
@set ARGS=
:: shift till last arg is %0
@set ARG=%0
@if not defined ARG goto got_args
@:more_args
@  set ARGS=%ARGS% %ARG%
@  shift
@  set ARG=%0
@  if not defined ARG goto got_args
@  goto more_args
@:got_args
@call %ICON% %ICNFILE% %ARGS%
@del %ICNFILE%
@goto :eof

This demonstrates a shebang implementation with arguments limited only
to the maximum size of an environment variable.
