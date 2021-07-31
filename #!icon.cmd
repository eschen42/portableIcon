@setlocal&set ICNFILE=%~dpnsx1.icn
@copy %~dpnsx1 %ICNFILE% >NUL
@set ICON=%~dps0icon.cmd&shift&shift
%ICON% %ICNFILE% %0 %1 %2 %3 %4 %5 %6 %7 %8 %9
@del %ICNFILE%
goto :eof

This demonstrates a shebang implementation limited to ten arguments.
TODO support more arguments.
