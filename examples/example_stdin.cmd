@REM NOT_ICON vim: sw=2 ts=2 et ai syntax=icon :
@ set ERRORLEVEL=& setlocal & (echo off)                                           & :: NOT_ICON
@ findstr /v "NOT_ICON" "%~dpnx0" | "%~dp0\..\icont.cmd" -o "%~dp0%~n0.exe" -v 0 - & :: NOT_ICON
@ call "%~dp0\..\bin\smudge.cmd" "%~dp0%~n0.exe"                                   & :: NOT_ICON
@ call "%~dp0%~n0.bat" %*                                                          & :: NOT_ICON
@ del "%~dp0\%~n0.bat" & exit /b %ERRORLEVEL%                                      & :: NOT_ICON

# world.icn is the Icon program to be translated and run

procedure main(args)
  write("There are ", *args, " args")
  every write(!args)
  every write(&features)
  write(&version)
end

