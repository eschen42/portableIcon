@cmd /c ^"set IPATH=%~dp0..\IPL^& type "%~dpnx1" ^| call "%~dp0\..\icont_nopath.cmd" -o "%~dp0%~n0" -v 0 - ^& if exist "%~dp0%~n0.bat" ( "%~dp0\..\nticonx.exe" "%~dp0%~n0.bat" %* ^& del "%~dp0%~n0.bat" ) else (echo translation FAILED) ^"