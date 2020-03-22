@ set ERRORLEVEL=& setlocal & (echo off) & set SENTINEL=33780A5A-52A9-40B6-A46D-2F0619E8B0E5& :: NOT_ICON
@ findstr /v "NOT_ICON" "%~dpnx0" | "%~dp0\..\icont.cmd" -o "%~dp0\%SENTINEL%.exe" -v 0 -   & :: NOT_ICON
@ "%~dp0\%SENTINEL%.exe" %*                                                                 & :: NOT_ICON
@ del "%~dp0\%SENTINEL%.exe" & exit /b %ERRORLEVEL%                                         & :: NOT_ICON
@ :: Note that you will likely want to make the SENTINEL unique for each script - sorry       :: NOT_ICON

# world.icn is the Icon program to be translated and run

procedure main(args)
  every write(!args)
  write(&version)
  every write(&features)
end

