  @set ERRORLEVEL=&set EXIT_CODE=1&setlocal&set ECHO_ON=off
  @echo %ECHO_ON%

  :: At least one argument is required
  set ARG1=&set ARG1=%1&set ARG1s=%~dpns1
  if not defined ARG1 goto usage
  set EXIT_CODE=0
  if /I ""%1"" == ""--help"" goto help
  if    ""%1"" == ""/?""     goto help
  if /I ""%1"" == ""-H""     goto help

set EXIT_CODE=1
set SMUDGE=smudge%RANDOM%
set ARG0=%~dpnxs0
set ARG0dir=%~dps0
set ARG0nx=%~nx0
set ARG1dir=%~dps1
set ARG1=%~dpns1
set ARG1long=%~dps1%~n1
set ARG1x=%~xs1
set ARG2=%2
set ARG3=%3
set ARG4=%4
if     defined ARG4 goto :usage
if not defined ARG1 goto :usage
if exist "%ARG1%.exe" set ARG1x=.exe
if not exist "%ARG1%%ARG1x%" goto :usage

if not defined ICONX set ICONX=%ARG0dir%nticonx.exe
fc /b "%ARG1%%ARG1x%" %ARG0dir%..\iconx.exe >NUL && goto :eof
:: Write the following inline text to file specified by the SMUDGE envar,
::   stopping at :HERE_END, using delayed-expansion syntax
pushd %~dps0
:::::::::::::::::::::::::: BEGIN INLINE TEXT  ::::::::::::::::::::::::::::::
call :heredoc :HERE_END > %ARG1dir%%SMUDGE% & goto :HERE_END || goto :HERE_ERROR
@echo off
set IXBIN=!ICONX!
setlocal
:: the unix seach order is ICONX, IXLCL, IXBIN, ./nticonx
::   ICONX can be defined to point to the executable and bypass the logic
::   IXLCL executes a local copy of nticonx, i.e, nticonx in same dir as icode
::   IXBIN is the path to nticonx inserted by icont the stub before the icode
::   if nothing else, search for nticonx on the search path
::
::   ICONX can be defined to point to the executable and bypass the logic
if defined ICONX goto :have_iconx
::   IXLCL executes a local copy of nticonx, i.e, %~dps0\nticonx.exe
set IXLCL=%~dps0nticonx.exe
if exist %IXLCL% set ICONX=%IXLCL%&goto :have_iconx
::   IXBIN is the path to nticonx inserted by icont the stub before the icode
if exist %IXBIN% set ICONX=%IXBIN%&goto :have_iconx
::   if nothing else, search PATH for iconx.cmd or iconx.bat
set ICONX=iconx

:have_iconx
%ICONX% %~dpnxs0 %*
exit /b %ERRORLEVEL%
:: unix stub follows

:HERE_END
:::::::::::::::::::::::::::: END INLINE TEXT  ::::::::::::::::::::::::::::::
popd
echo %ECHO_ON%

:: You can un-comment out the next echo line if you run your programs by
::   double-cliking and don't want the window to close immedately
::   after the program finishes.
:: echo pause>> %SMUDGE%

move /y %ARG1%%ARG1x% %ARG1%.%SMUDGE% >NUL
copy /y %ARG1dir%%SMUDGE% "%ARG1long%.bat" >NUL
type %ARG1%.%SMUDGE% >> "%ARG1long%.bat"
if "%ARG1X%" == ".exe" (
  del  %ARG1DIR%%SMUDGE% %ARG1%.%SMUDGE%
) else (
  del  %ARG1DIR%%SMUDGE%
  move %ARG1%.%SMUDGE% %ARG1%%ARG1x% >NUL
)
if not defined ARG2 exit/b 0

set STANDALONE=0
set ADD_EXE=0
if "%ARG2%" == "--standalone" set STANDALONE=1
if "%ARG2%" == "--add-exe" set ADD_EXE=1
if "%ARG3%" == "--standalone" set STANDALONE=1
if "%ARG3%" == "--add-exe" set ADD_EXE=1
if 1 == %STANDALONE% (
  if not exist %ARG1dir%nticonx.exe copy %ARG0dir%nticonx.exe %ARG1dir%nticonx.exe >NUL
  if not exist %ARG1dir%cygwin1.dll copy %ARG0dir%cygwin1.dll %ARG1dir%cygwin1.dll >NUL
)
if 1 == %ADD_EXE% (
  copy %ARG0dir%..\iconx.exe "%ARG1long%.exe" >NUL
)
exit/b 0

:HERE_ERROR
echo %~nx0: Unable to write execution stub for icode
exit /b 1


::::::::::::::::::::::::::: :heredoc subroutine ::::::::::::::::::::::::::::
:: https://github.com/ildar-shaimordanov/cmd.scripts/blob/master/heredoc.bat
:: ref: https://stackoverflow.com/a/29329912
:: ref: https://stackoverflow.com/a/15032476/3627676
::
:heredoc LABEL
  @echo off
  setlocal enabledelayedexpansion
  if not defined CMDCALLER set "CMDCALLER=%~f0"
  set go=
  for /f "delims=" %%A in ( '
    findstr /n "^" "%CMDCALLER%"
  ' ) do (
    set "line=%%A"
    set "line=!line:*:=!"

    if defined go (
      if /i "!line!" == "!go!" goto :EOF
      echo:!line!
    ) else (
      rem delims are @ ( ) > & | TAB , ; = SPACE
      for /f "tokens=1-3 delims=@()>&|	,;= " %%i in ( "!line!" ) do (
        if /i "%%i %%j %%k" == "call :heredoc %1" set "go=%%k"
        if /i "%%i %%j %%k" == "call heredoc %1" set "go=%%k"
        if defined go if not "!go:~0,1!" == ":" set "go=:!go!"
      )
    )
  )
  set ECHO=%ECHO_ON%
  @goto :EOF
::::::::::::::::::::::::: end :heredoc subroutine ::::::::::::::::::::::::::

:usage
  set EXIT_CODE=1
  if defined ARG1 echo %~nxs0 %*
  if not defined ARG1 (
    echo.
    echo.%~nxs0: at least one argument is required
  )

:help
  echo.
  echo.usage: %~nx0 icode [--standalone] [--add-exe]
  echo.  produces:
  echo.    icode.bat - (if icode has a file extension, it is omitted)
  echo.    icode.exe - (when --add-exe is specified)
  echo.    nticonx.exe - (when --standalone is specified)
  echo.    cygwin1.dll - (when --standalone is specified)
  echo.  where:
  echo.    icode is a file containing a translated Icon program
  exit /b %EXIT_CODE%
