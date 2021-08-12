@set ERRORLEVEL=&setlocal&set ECHO_ON=off
@echo %ECHO_ON%
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
if     defined ARG3 goto :usage
if not defined ARG1 goto :usage
if not exist "%ARG1%.exe" goto :usage
if /I not "%ARG1x%" == ".exe" goto :usage
if not defined ICONX set ICONX=%ARG0dir%nticonx.exe
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
del  %ARG1dir%%SMUDGE% %ARG1%.%SMUDGE%
if not defined ARG2 exit/b 0
if not "%ARG2%" == "--standalone" exit/b 0
if not exist %ARG1dir%nticonx.exe copy %ARG0dir%nticonx.exe %ARG1dir%nticonx.exe >NUL
if not exist %ARG1dir%cygwin1.dll copy %ARG0dir%cygwin1.dll %ARG1dir%cygwin1.dll >NUL
exit/b 0

:HERE_ERROR
echo %~nx0: Unable to write execution stub for icode
exit /b 1

:usage

echo "usage: %~nx0 <icode.exe>"
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
