@ set ERRORLEVEL=&setlocal&echo off
@ set SENTINEL=findstr& set PROMPT=running -$G &set ECHO_ON=off
:: single-ampersand means execute second command regardless of EXITCODE from first command

pushd %~dps0

:: Extract world.icn from example_stdin.cmd
findstr /v "%SENTINEL%" example_stdin.cmd > world.icn

:: Delete any pre-existing executable
if exist "%~dp0world.exe" del "%~dp0world.exe"
if exist "%~dp0world.bat" del "%~dp0world.bat"

@echo.
@echo -------  Here is the Icon program used for these examples ---------
type "%~dp0world.icn"

@echo -------  Test one   - Translate with default options [1]  ---------
@echo.
set PROMPT=running one -$G
@echo %ECHO_ON%
(call "%~dp0..\icont.cmd" "%~dp0world.icn") >NUL 2>&1

@echo %ECHO_ON%
call "%~dp0world.bat" one
@echo off

del "%~dp0world.bat"

@echo.
@echo -------  Test two   - Translate with custom options [2]  ---------
@echo.
set PROMPT=running two -$G
@echo %ECHO_ON%
call "%~dp0..\icont.cmd" -s -u -o "%~dp0mundo.exe" "%~dp0world.icn" 2>&1
call "%~dp0..\bin\smudge.cmd" "%~dp0mundo.exe" --standalone
if not exist "%~dp0cygwin1.dll" echo cygwin1.dll required for standalone execution was not found
if not exist "%~dp0nticonx.exe" echo nticonx.exe required for standalone execution was not found
@echo %ECHO_ON%
call "%~dp0mundo.bat" one two
@echo off

:: prep for next test
if exist "%~dp0cygwin1.dll" del "%~dp0cygwin1.dll"
if exist "%~dp0nticonx.exe" del "%~dp0nticonx.exe"
if exist "%~dp0mundo.bat" del "%~dp0mundo.bat"
if exist "%~dp0world.icn" del "%~dp0world.icn"
@echo.
@echo -------  Test three - Translate from within a script and run [3]  ---------
@echo.
set PROMPT=running three -$G
:: It is imperative that you use "call";
::   otherwise, the rest of the script is ignored.
@echo %ECHO_ON%
call example_stdin.cmd one two three
@echo off

:: Extract world.icn from example_stdin.cmd for next test
findstr /v "%SENTINEL%" example_stdin.cmd > world.icn
@echo.
@echo -------  Test four  - Explicity run the Icon Virtual Machine [4]  ---------
@echo.
set PROMPT=running four -$G
@echo. 4a. Invoke the Icon translator explicitly
@echo %ECHO_ON%
"%~dp0..\bin\nticont.exe" -s -u "%~dp0world.icn"
@echo.
@echo. 4b. Invoke the Icon runtime explicitly
@echo %ECHO_ON%
"%~dp0..\bin\nticonx.exe" "%~dp0world.exe" one two three four
del "%~dp0world.exe"
@echo off

@echo.
@echo %ECHO_ON%
@echo. 4c. Invoke the Icon translator by proxy - icont.exe to icont.cmd to nticont.exe
"%~dp0..\icont.exe" -s -u "%~dp0world.icn"
@echo.
@echo %ECHO_ON%
@echo. 4d. Invoke the Icon runtime by proxy - iconx.exe to iconx.cmd to nticonx.exe
"%~dp0..\iconx.exe" "%~dp0world.bat" won too three faure
@echo off

setlocal

@echo.
@echo -------  Test five  - Implicity run the Icon Virtual Machine using CMD [5]  ---------
@echo.
"%~dp0..\icont.exe" -s -u -o "%~dp0world.exe" "%~dp0world.icn"
call "%~dp0..\bin\smudge.cmd" "%~dp0world.exe"
set PROMPT=running five -$G
set OLD_PATH=%PATH%
set PATH=%~dp0..;%PATH%
@echo %ECHO_ON%
cmd /c ^""%~dp0world.bat" one two three four five^"
@echo off

@echo.
@echo -------  Test six  - Implicity run the Icon Virtual Machine in the background using START [6]  ---------
@echo.
set PROMPT=running six -$G
@echo %ECHO_ON%
start "demo start" /b "%windir%\system32\cmd.exe" /c ""%~dp0world.bat" one two three four five six^"
>NUL ping -n 2 localhost
@echo off

if exist "%~dp0world.bat" del "%~dp0world.bat"
if exist "%~dp0world.exe" del "%~dp0world.exe"

endlocal

@echo.
@echo -------  Test seven  -  Do not include the Icon Virtual Machine in the output file [7]  ---------
@echo.

set PROMPT=running seven -$G

set PATH=OLD_%PATH%
@echo %ECHO_ON%
call "%~dp0..\icont_nosmudge.cmd" -s -u "%~dp0world.icn"

@echo %ECHO_ON%
if not exist "%~dp0world.exe" echo Unexpectedly NOT having to smudge "world.exe"
if exist "%~dp0world.exe" call "%~dp0..\bin\smudge.cmd" "%~dp0world.exe" >NUL
@echo %ECHO_ON%
if exist "%~dp0world.bat" call "%~dp0world.bat" uno deux drei tessera cinque seis seven
@echo off

if exist "%~dp0world.bat" del "%~dp0world.bat"
if exist "%~dp0world.bat" del "%~dp0world.bat"

@echo.
@echo -------  Test eight  -  Shebang example [8]  ---------
@echo.

set PROMPT=running eight -$G


:: the shebang line in this case is NOT emitted because echo is OFF
call "%~dp0example_shebang.cmd" ten nine eight seven six five four three two one zero "blast off"
@echo off

@echo.
@echo -------  Test nine  -  icon.cmd invokes icont.cmd and iconx.cmd [9]  ---------
@echo.

set PROMPT=running nine -$G

@echo %ECHO_ON%
@echo. 9a. Invoke the icon.cmd script with quotes in the source file name
call %~dps0..\icon.cmd "%~dps0world.icn" nine "with quoted path to Icon source"
@echo.
@echo. 9b. Invoke the icon.cmd script without quotes in the source file name
call %~dps0..\icon.cmd %~dps0world.icn nine "without quoted path to Icon source"
@echo.
@echo. 9c. Invoke the icon.cmd script on source from stdin
type "%~dp0world.icn" | %~dps0..\icon.cmd - nine "with Icon source from stdin"
@echo.
@echo. 9d. Invoke the icont.cmd [not icono.cmd] script with spaces in file name
copy "%~dp0world.icn" "%~dp0mio mundo.icn" >NUL
:: double-ampersand means execute second command only if first command returns zero EXITCODE
call %~dps0..\icont.cmd -v0 "%~dps0mio mundo.icn"&& call "%~dps0mio mundo.bat" nine "via icont.cmd (rather than icon.cmd)"
if exist "%~dp0mio mundo.icn" del "%~dp0mio mundo.icn"
if exist "%~dp0mio mundo.bat" del "%~dp0mio mundo.bat"
@echo off

@echo.
@echo -------  "Where there's smoke, there's fire." -Anonymous ---------

popd
endlocal
