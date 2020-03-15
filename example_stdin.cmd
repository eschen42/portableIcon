@findstr /v "xYzzy" "%~dpnx0" | icont - -v 0 & a.exe & del a.exe
@exit /b %ERRORLEVEL% & xYzzy

procedure main()
  write("hello world")
end
