@ set ERRORLEVEL=&setlocal&echo off
@ set SENTINEL=NOT_ICON& set PROMPT=running -$G &set ECHO_ON=off

:: Extract world.icn from example_stdin.cmd
findstr /v "%SENTINEL%" example_stdin.cmd > world.icn
:: Delete any pre-existing executable
if exist "%~dp0world.exe" del "%~dp0world.exe"

echo -------  Here is the Icon program used for these examples ---------
type "%~dp0world.icn"

echo -------  Test one   - Translate with default options [1]  ---------
set PROMPT=running one -$G
@echo %ECHO_ON%
call "%~dp0..\icont.cmd" "%~dp0world.icn"
"%~dp0world.exe" one
@echo off

del "%~dp0world.exe"

echo -------  Test two   - Translate with custom options [2]  ---------
set PROMPT=running two -$G
@echo %ECHO_ON%
call "%~dp0..\icont.cmd" -s -u -o "%~dp0world.exe" "%~dp0world.icn"
"%~dp0world.exe" one two
@echo off

:: prep for next test
if exist "%~dp0world.exe" del "%~dp0world.exe"
if exist "%~dp0world.icn" del "%~dp0world.icn"
echo -------  Test three - Translate from within a script and run [3]  ---------
set PROMPT=running three -$G
:: It is imperative that you use "call";
::   otherwise, the rest of the script is ignored.
@echo %ECHO_ON%
call example_stdin.cmd one two three
@echo off

:: Extract world.icn from example_stdin.cmd for next test
findstr /v "%SENTINEL%" example_stdin.cmd > world.icn
echo -------  Test four  - Explicity run the Icon Virtual Machine [4]  ---------
set PROMPT=running four -$G
@echo %ECHO_ON%
"%~dp0..\nticont.exe" -s -u "%~dp0world.icn"
"%~dp0..\nticonx.exe" "%~dp0world.bat" one two three four
@echo off

setlocal

echo -------  Test five  - Implicity run the Icon Virtual Machine using CMD [5]  ---------
:: note that world.bat calls noop.bat
set PROMPT=running five -$G
@echo %ECHO_ON%
set PATH=%~dp0..;%PATH%
cmd /c ^""%~dp0world.bat" one two three four five^"
@echo off

echo -------  Test six  - Implicity run the Icon Virtual Machine in the background using START [6]  ---------
set PROMPT=running six -$G
@echo %ECHO_ON%
start "demo start" /b "%windir%\system32\cmd.exe" /c ""%~dp0world.bat" one two three four five six^"
>NUL ping -n 2 localhost
@echo off

if exist "%~dp0world.exe" del "%~dp0world.exe"
if exist "%~dp0world.bat" del "%~dp0world.bat"

endlocal

echo -------  Test seven  -  Do not include the Icon Virtual Machine in the output file [7]  ---------

set PROMPT=running seven -$G

@echo %ECHO_ON%
call "%~dp0..\icont_nopath.cmd" -s -u "%~dp0world.icn"

@echo %ECHO_ON%
if exist "%~dp0world.bat" call "%~dp0..\smudge_nopath.cmd" "%~dp0world.bat" >NUL
@echo %ECHO_ON%
if exist "%~dp0world.bat" call "%~dp0world.bat" uno deux drei tessera cinque seis seven
@echo off

if exist "%~dp0world.exe" del "%~dp0world.exe"
if exist "%~dp0world.bat" del "%~dp0world.bat"

echo -------  Test eight  -  Shebang example [8]  ---------

@echo off
:: the shebang line in this case is NOT emitted because echo is OFF
call "%~dp0example_shebang.cmd" eight is enough

echo -------  "Where there's smoke, there's fire." -Anonymous ---------
endlocal
