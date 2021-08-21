  @set ERRORLEVEL=&set EXIT_CODE=1&setlocal&set ECHO_ON=off
  @echo %ECHO_ON%

  :: At least one argument is required
  set ARG1=&set ARG1=%1&set ARG1s=%~dpns1
  if not defined ARG1 goto usage
  set EXIT_CODE=0
  if /I ""%1"" == ""--help"" goto help
  if    ""%1"" == ""/?""     goto help
  if /I ""%1"" == ""-H""     goto help


  @%~dps0bin\nticonx.exe %*
  @exit /b %ERRORLEVEL%


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
  set NX0=%~nx0
  set DP0=%~dp0
  set DPNX0=%~dpnx0
  call :heredoc :post_usage & goto :post_usage
-------------------------------------------------------------------------------
# iconx usage

usage: !NX0! icode-file-name [arguments for Icon program]

You can find !NX0! at !DPNX0!

Environmental variables recognized by !NX0!

Name         Default    Description
---------    -------    ----------------------------------------------------
TRACE              0    Initial value for &trace.
NOERRBUF   undefined    If set, &errout is not buffered.
STRSIZE       500000    Initial size (bytes) of string region (strings).
BLKSIZE       500000    Initial size (bytes) of block region (most objects).
COEXPSIZE       2000    Size (long words) of co-expression blocks.
MSTKSIZE       10000    Size (long words) of main interpreter stack.
ICONPROFILE     none    Output file for execution profile.
-------------------------------------------------------------------------------

:post_usage

exit /b %EXIT_CODE%
