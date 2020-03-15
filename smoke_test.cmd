@set ERRORLEVEL=&setlocal&echo off& set SENTINEL=33780A5A-52A9-40B6-A46D-2F0619E8B0E5
@findstr /v "%SENTINEL%" example_stdin.cmd > world.icn
@if exist "%~dp0\world.exe" del "%~dp0\world.exe"
call "%~dp0\icont.cmd" "%~dp0\world.icn"

echo -------  test one ---------
"%~dp0\world.exe" one

del "%~dp0\world.exe"
call "%~dp0\icont.cmd" -s -u -o "%~dp0\world.exe" "%~dp0\world.icn"

echo -------  test two  ---------
"%~dp0\world.exe" two

echo -------  test three  ---------
call example_stdin.cmd three
