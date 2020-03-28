@ set ERRORLEVEL=&setlocal&echo off
@ set SENTINEL=NOT_ICON& set PROMPT=running -$G &set ECHO_ON=on

:: Extract world.icn from example_stdin.cmd
findstr /v "%SENTINEL%" example_stdin.cmd > world.icn
:: Delete any pre-existing executable
if exist "%~dp0world.exe" del "%~dp0world.exe"

echo -------  Here is the Icon program used for these examples ---------
type "%~dp0world.icn"

echo -------  Test one   - Translate with default options ---------
set PROMPT=running one -$G 
@echo %ECHO_ON%
call "%~dp0..\icont.cmd" "%~dp0world.icn"
"%~dp0world.exe" one
@echo off

del "%~dp0world.exe"

echo -------  Test two   - Translate with custom options ---------
set PROMPT=running two -$G 
@echo %ECHO_ON%
call "%~dp0..\icont.cmd" -s -u -o "%~dp0world.exe" "%~dp0world.icn"
"%~dp0world.exe" one two
@echo off

:: prep for next test
if exist "%~dp0world.exe" del "%~dp0world.exe"
if exist "%~dp0world.icn" del "%~dp0world.icn"
echo -------  Test three - Translate from within a script and run ---------
set PROMPT=running three -$G 
:: It is imperative that you use "call";
::   otherwise, the rest of the script is ignored.
@echo %ECHO_ON%
call example_stdin.cmd one two three
@echo off

:: Extract world.icn from example_stdin.cmd for next test
findstr /v "%SENTINEL%" example_stdin.cmd > world.icn
echo -------  Test four  - Explicity run the Icon Virtual Machine ---------
set PROMPT=running four -$G 
@echo %ECHO_ON%
"%~dp0..\nticont.exe" -s -u "%~dp0world.icn"
"%~dp0..\nticonx.exe" "%~dp0world.bat" one two three four
@echo off

echo -------  Test five  - Implicity run the Icon Virtual Machine using CMD ---------
:: note that world.bat calls noop.bat
set PROMPT=running five -$G 
@echo %ECHO_ON%
set PATH=%~dp0..;%PATH%
cmd /c ^""%~dp0world.bat" one two three four five^"
@echo off

echo -------  Test six  - Implicity run the Icon Virtual Machine in the background using START ---------
set PROMPT=running six -$G 
@echo %ECHO_ON%
start "demo start" /b "%windir%\system32\cmd.exe" /c ""%~dp0world.bat" one two three four five six^"
>NUL ping -n 2 localhost
@echo off

echo -------  "Where there's smoke, there's fire." -Anonymous ---------
endlocal
