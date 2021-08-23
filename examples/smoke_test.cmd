@ set ERRORLEVEL=& setlocal& set SENTINEL=findstr& set PROMPT=running -$G& set ECHO_ON=off
@ echo %ECHO_ON%
:: single-ampersand means execute second command regardless of EXITCODE from first command

set EXIT_CODE=0
set EXIT_MSG=%~n0 SUCCEEDED
set TEST_NAME=initialization

pushd %~dps0

:: Extract world.icn from example_stdin.cmd
findstr /v "%SENTINEL%" example_stdin.cmd > world.icn

:: Delete any pre-existing executable
if exist "%~dp0world.exe" del "%~dp0world.exe"
if exist "%~dp0world.bat" del "%~dp0world.bat"

@echo.
@echo -------  Here is the Icon program used for these examples ---------
type "%~dp0world.icn"
if %ERRORLEVEL% neq 0 (
  call :fail_msg fubar does not exist
  goto :farewell
)

@echo -------  Test one   - Translate with default options [1]  ---------
@echo -------  Test one   - Translate with default options [1] 1>&2
@echo.

set PROMPT=running one -$G
(call "%~dp0..\icont.cmd" "%~dp0world.icn") >NUL 2>&1

@ if %ERRORLEVEL% neq 0 (
  set TEST_NAME=one translation
  call :fail_msg icont.cmd world.icn failed
  goto :farewell
)

call "%~dp0world.bat" one
@echo off
@ if %ERRORLEVEL% neq 0 (
  set TEST_NAME=one execution
  call :fail_msg call world.bat failed
  goto :farewell
)

del "%~dp0world.bat"

@echo.
@echo -------  Test two   - Translate with custom options [2]  ---------
@echo -------  Test two   - Translate with custom options [2] 1>&2
@echo.

set PROMPT=running two -$G
@echo %ECHO_ON%
call "%~dp0..\icont.cmd" -s -u -o "%~dp0Welt.exe" --standalone "%~dp0world.icn" 2>&1
@ if %ERRORLEVEL% neq 0 (
  set TEST_NAME=two translation
  call :fail_msg icont.cmd -o Welt.exe world.icn failed
  goto :farewell
)
@if not exist "%~dp0Welt.bat" (
  set TEST_NAME=two no icode
  call :fail_msg icont -o did not produce expected icode .bat file
  goto :farewell
)
if not exist "%~dp0cygwin1.dll" echo cygwin1.dll required for standalone execution was not found
if not exist "%~dp0nticonx.exe" echo nticonx.exe required for standalone execution was not found
if not exist "%~dp0Welt.exe" echo icode .exe file was not produced implicitly by -o .exe
@echo %ECHO_ON%
call "%~dp0Welt.bat" one two
@echo off
@ if %ERRORLEVEL% neq 0 (
  set TEST_NAME=two execution
  call :fail_msg call Welt.bat failed
  goto :farewell
)
if exist "%~dp0world.exe" del "%~dp0world.exe"
call "%~dp0..\icont.cmd" -s -u --add-exe "%~dp0world.icn" 2>&1 >NUL
@if not exist "%~dp0world.exe" (
  dir
  set TEST_NAME=two no added exe
  call :fail_msg icont --add-exe did not produce expected stub .exe file
  goto :farewell
)

:: prep for next test
if exist "%~dp0cygwin1.dll" del "%~dp0cygwin1.dll"
if exist "%~dp0nticonx.exe" del "%~dp0nticonx.exe"
if exist "%~dp0Welt.bat" del "%~dp0Welt.bat"
if exist "%~dp0world.icn" del "%~dp0world.icn"
@echo.
@echo -------  Test three - Translate from within a script and run [3]  ---------
@echo -------  Test three - Translate from within a script and run [3] 1>&2
@echo.

set PROMPT=running three -$G
:: It is imperative that you use "call";
::   otherwise, the rest of the script is ignored.
@echo %ECHO_ON%
call example_stdin.cmd one two three
@ if %ERRORLEVEL% neq 0 (
  set TEST_NAME=three translation and execution
  call :fail_msg call example_stdin.cmd failed
  goto :farewell
)
@echo off

:: Extract world.icn from example_stdin.cmd for next test
findstr /v "%SENTINEL%" example_stdin.cmd > world.icn
@echo.
@echo -------  Test four  - Explicity run the Icon Virtual Machine [4]  ---------
@echo -------  Test four  - Explicity run the Icon Virtual Machine [4] 1>&2
@echo.

set PROMPT=running four -$G
@echo. 4a. Invoke the Icon translator explicitly
@echo %ECHO_ON%
"%~dp0..\bin\nticont.exe" -s -u "%~dp0world.icn"
@ if %ERRORLEVEL% neq 0 (
  set TEST_NAME=four a. translation
  call :fail_msg call bin\nticont.exe world.icn failed
  goto :farewell
)
@echo.
@echo. 4b. Invoke the Icon runtime explicitly
@echo %ECHO_ON%
"%~dp0..\bin\nticonx.exe" "%~dp0world.exe" one two three four
@ if %ERRORLEVEL% neq 0 (
  set TEST_NAME=four b. execution
  call :fail_msg call bin\nticonx.exe world.exe failed
  goto :farewell
)
del "%~dp0world.exe"
@echo off

@echo.
@echo %ECHO_ON%
@echo. 4c. Invoke the Icon translator by proxy - icont.exe to icont.cmd to nticont.exe
"%~dp0..\icont.exe" -s -u "%~dp0world.icn"
@ if %ERRORLEVEL% neq 0 (
  set TEST_NAME=four c. translation
  call :fail_msg call icont.exe world.icn failed
  goto :farewell
)
@echo.
@echo %ECHO_ON%
@echo. 4d. Invoke the Icon runtime by proxy - iconx.exe to iconx.cmd to nticonx.exe
"%~dp0..\iconx.exe" "%~dp0world.bat" won too three faure
@ if %ERRORLEVEL% neq 0 (
  set TEST_NAME=four d. execution
  call :fail_msg call iconx.exe world.exe failed
  goto :farewell
)
@echo off

setlocal

@echo.
@echo -------  Test five  - Implicity run the Icon Virtual Machine using CMD [5]  ---------
@echo -------  Test five  - Implicity run the Icon Virtual Machine using CMD [5] 1>&2
@echo.

"%~dp0..\icont.exe" -s -u -o "%~dp0world.exe" "%~dp0world.icn"
@ if %ERRORLEVEL% neq 0 (
  set TEST_NAME=five translation
  call :fail_msg call icont.exe -o world.exe world.icn failed
  goto :farewell
)
:: dir world.*
:: call "%~dp0..\bin\smudge.cmd" "%~dp0world.exe"
:: @ if %ERRORLEVEL% neq 0 (
::   set TEST_NAME=five smudge
::   call :fail_msg call bin\smudge.cmd world.exe failed
::   goto :farewell
:: )
:: dir world.*
set PROMPT=running five -$G
set OLD_PATH=%PATH%
set PATH=%~dp0..;%PATH%
@echo %ECHO_ON%
cmd /c ^""%~dp0world.bat" one two three four five^"
@ if %ERRORLEVEL% neq 0 (
  set TEST_NAME=five execution
  call :fail_msg call cmd /c world.bat failed
  goto :farewell
)
@echo off

@echo.
@echo -------  Test six   - Implicity run the Icon Virtual Machine in the background using START [6]  ---------
@echo -------  Test six   - Implicity run the Icon Virtual Machine in the background using START [6] 1>&2
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
@echo -------  Test seven - Do not include the Icon Virtual Machine in the output file [7]  ---------
@echo -------  Test seven - Do not include the Icon Virtual Machine in the output file [7] 1>&2
@echo.

set PROMPT=running seven -$G

set PATH=OLD_%PATH%
@echo %ECHO_ON%
call "%~dp0..\icont_nosmudge.cmd" -s -u "%~dp0world.icn"
@ if %ERRORLEVEL% neq 0 (
  set TEST_NAME=seven translation
  call :fail_msg call icont_nosmudge.cmd world.icn failed
  goto :farewell
)

if exist "%~dp0world.bat" echo Unexpectedly found "world.bat"
if exist "%~dp0world.bat" (
  @ if %ERRORLEVEL% neq 0 (
    set TEST_NAME=seven wrot translation output not present
    call :fail_msg call icont_nosmudge.cmd world.icn produced world.bat
    goto :farewell
  )
)

@echo %ECHO_ON%
if not exist "%~dp0world.exe" echo Unexpectedly NOT having to smudge "world.exe"
if not exist "%~dp0world.exe" (
  @ if %ERRORLEVEL% neq 0 (
    set TEST_NAME=seven nosmudge
    call :fail_msg call icont_nosmudge.cmd world.icn unexpectedly smudged
    goto :farewell
  )
)
if exist "%~dp0world.exe" call "%~dp0..\bin\smudge.cmd" "%~dp0world.exe" >NUL
@ if %ERRORLEVEL% neq 0 (
  set TEST_NAME=seven smudge
  call :fail_msg call bin\smudge.cmd world.exe failed
  goto :farewell
)
@echo %ECHO_ON%
if exist "%~dp0world.bat" call "%~dp0world.bat" uno deux drei tessera cinque seis seven
@ if %ERRORLEVEL% neq 0 (
  set TEST_NAME=seven execution
  call :fail_msg call world.bat failed
  goto :farewell
)
@echo off

if exist "%~dp0world.bat" del "%~dp0world.bat"
if exist "%~dp0world.bat" del "%~dp0world.bat"

@echo.
@echo -------  Test eight - Shebang example [8]  ---------
@echo -------  Test eight - Shebang example [8] 1>&2
@echo.

set PROMPT=running eight -$G


:: the shebang line in this case is NOT emitted because echo is OFF
call "%~dp0example_shebang.cmd" ten nine eight seven six five four three two one zero "blast off"
@ if %ERRORLEVEL% neq 0 (
  set TEST_NAME=eight translation and execution
  call :fail_msg call example_shebang.cmd failed
  goto :farewell
)
@echo off

@echo.
@echo -------  Test nine  - icon.cmd invokes icont.cmd and iconx.cmd [9]  ---------
@echo -------  Test nine  - icon.cmd invokes icont.cmd and iconx.cmd [9] 1>&2
@echo.

set PROMPT=running nine -$G

@echo %ECHO_ON%
@echo. 9a. Invoke the icon.cmd script with quotes in the source file name
call %~dps0..\icon.cmd "%~dps0world.icn" nine "with quoted path to Icon source" hello world
@ if %ERRORLEVEL% neq 0 (
  set TEST_NAME=nine a. translation and execution
  call :fail_msg call icon quoted world.icn failed
  goto :farewell
)
@echo.
@echo. 9b. Invoke the icon.cmd script without quotes in the source file name
call %~dps0..\icon.cmd %~dps0world.icn nine "without quoted path to Icon source" hello world
@ if %ERRORLEVEL% neq 0 (
  set TEST_NAME=nine b. translation and execution
  call :fail_msg call icon unquoted world.icn failed
  goto :farewell
)
@echo.
@echo. 9c. Invoke the icon.cmd script on source from stdin
type "%~dp0world.icn" | %~dps0..\icon.cmd - nine "with Icon source from stdin" hello world
@ if %ERRORLEVEL% neq 0 (
  set TEST_NAME=nine c. translation and execution
  call :fail_msg call icon piped script failed
  goto :farewell
)
@echo.
@echo. 9d. Invoke the icont.cmd [not icono.cmd] script with spaces in file name
copy "%~dp0world.icn" "%~dp0meine Welt.icn" >NUL
:: double-ampersand means execute second command only if first command returns zero EXITCODE
call %~dps0..\icont.cmd -v0 "%~dps0meine Welt.icn"&& call "%~dps0meine Welt.bat" nine "via icont.cmd (rather than icon.cmd)" hello world
@ if %ERRORLEVEL% neq 0 (
  set TEST_NAME=nine d. translation and execution
  call :fail_msg call icon quoted script with spaces in name failed
  goto :farewell
)
if exist "%~dp0meine Welt.icn" del "%~dp0meine Welt.icn"
if exist "%~dp0meine Welt.bat" del "%~dp0meine Welt.bat"
@ echo %ECHO_ON%

@echo.
@echo -------  Test ten   - preprocessing and ucode example [10]  ---------
@echo -------  Test ten   - preprocessing and ucode example [10] 1>&2
@echo.

set PROMPT=running ten -$G

:: display the two .icn files by preprocessing them
(call "%~dp0..\icont.cmd" -E "%~dp0mundo.icn" 2>&1)| findstr /v "#line errors mundo.icn"
(call "%~dp0..\icont.cmd" -E "%~dp0luna.icn"  2>&1)| findstr /v "#line errors luna.icn"

:: create ucode for luna.icn (translate but do not link)
(call "%~dp0..\icont.cmd" -c "%~dp0luna.icn") >NUL 2>&1
@ if %ERRORLEVEL% neq 0 (
  set TEST_NAME=ten luna translation
  call :fail_msg icont.cmd -c luna.icn failed
  goto :farewell
)

:: move luna.* to moon.* to ensure that luna.icn is not translated by accident
if exist "%~dp0moon.u1" del /q "%~dp0moon.u1"
if exist "%~dp0moon.u2" del /q "%~dp0moon.u2"
rename "%~dp0luna.u1" moon.u1
rename "%~dp0luna.u2" moon.u2
(call "%~dp0..\icont.cmd" -o world "%~dp0mundo.icn" "%~dp0moon.u1" "%~dp0moon.u2") >NUL 2>&1

@ if %ERRORLEVEL% neq 0 (
  set TEST_NAME=ten mundo translation
  call :fail_msg icont.cmd -o world.exe mundo.icn moon.u1 moon.u2 failed
  goto :farewell
)

call "%~dp0world.exe" ten cent store

@ if %ERRORLEVEL% neq 0 (
  set TEST_NAME=ten execution
  call :fail_msg call world.exe failed
  goto :farewell
)

del "%~dp0world.bat"
del "%~dp0world.exe"

goto farewell


:fail_msg

set EXIT_CODE=%ERRORLEVEL%
echo %~n0 test %TEST_NAME% FAILED: %* 1>&2
set EXIT_MSG=smoke test FAILED
echo !!!!!  %EXIT_MSG%  !!!!!
echo !!!!!  %EXIT_MSG%  !!!!! 1>&2

goto :eof


:farewell

popd

@echo.
if %EXIT_CODE% equ 0 @echo -------  "Where there's smoke, there's fire." -Anonymous ---------
if %EXIT_CODE% equ 0 @echo -------  "Where there's smoke, there's fire." -Anonymous --------- 1>&2

endlocal&exit /b %EXIT_CODE%
