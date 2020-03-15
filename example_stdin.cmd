@set ERRORLEVEL=&setlocal&echo off& set SENTINEL=33780A5A-52A9-40B6-A46D-2F0619E8B0E5
@findstr /v "33780A5A-52A9-40B6-A46D-2F0619E8B0E5" "%~dpnx0" | "%~dp0\icont.cmd" -o %SENTINEL%.exe -v 0 - & %SENTINEL%.exe %* & del %SENTINEL%.exe
@exit /b %ERRORLEVEL% & :: 33780A5A-52A9-40B6-A46D-2F0619E8B0E5

procedure main(args)
  every write(!args)
  write(&version)
  every write(&features)
end
