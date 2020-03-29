@REM NOT_ICON vim: sw=2 ts=2 et ai syntax=icon :
@ set ERRORLEVEL=& setlocal & (echo off)                                           & :: NOT_ICON
@ findstr /v "NOT_ICON" "%~dpnx0" | "%~dp0\..\icont.cmd" -o "%~dp0%~n0.exe" -v 0 - & :: NOT_ICON
@ "%~dp0%~n0.exe" %*                                                               & :: NOT_ICON
@ del "%~dp0\%~n0.exe" & exit /b %ERRORLEVEL%                                      & :: NOT_ICON

# world.icn is the Icon program to be translated and run

procedure main(args)
  every write(!args)
  every write(&features)
  write(&progname)
  write(&version)
end

