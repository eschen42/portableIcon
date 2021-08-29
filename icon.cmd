  @echo off
  setlocal

  set FORCED_UNQUOTE=
  set FORCED_QUOTE=
  set ARGS=
  set ICONT_ARGS=
  set ARG0=%~dps0
  set ARG=%1
  set ICN_FILE=
  set ICX_FILE=
  if not defined ARG goto usage_ERROR

  set FORCED_QUOTE_RESULT=ARG
  call :force_quote %1
  set FORCED_QUOTE_RESULT=ARG_no_x
  call :force_quote %~dpn1
  set ARG_x=%~x1

  :: shift till last arg is %1
:more_args
    if /I ""%ARG%"" == ""--help"" goto usage
    if    ""%ARG%"" == ""/?""     goto usage
    if /I ""%ARG%"" == ""-H""     goto usage
    set ARG2=%2
    set JUST_DEFINED=
    if defined ICN_FILE goto next_arg
      call :force_quote %ARG%
      set JUST_DEFINED=true
      set ICONT_ARGS=%ARGS%
      if not exist "%FORCED_UNQUOTE%" goto no_file_exists
        if /i not "%~x1" == ".icn" goto no_file_exists
        set ICN_FILE=%FORCED_UNQUOTE%
        set ICX_FILE=%FORCED_UNQUOTE:~0,-4%.bat
        set ICNSRCdpnsx=%~dpnxs1
        set ICNSRCdpns=%~dpns1
        set ICNSRCdps=%~dps1
        set ICNSRCns=%~ns1
        set ICONT_ARGS=%ARGS%
        set ARGS=
      :no_file_exists
      if not exist "%FORCED_UNQUOTE%.icn" goto no_icn_exists
        set ICN_FILE=%FORCED_UNQUOTE%.icn
        set ICX_FILE=%FORCED_UNQUOTE%.bat
        set ICNSRCdpnsx=%~dpnxs1
        set ICNSRCdpns=%~dpns1
        set ICNSRCdps=%~dps1
        set ICNSRCns=%~ns1
        set ICONT_ARGS=%ARGS%
        set ARGS=
      :no_icn_exists
      if "%~ns1" == "-" set ICN_FILE=-& set ICNSRCns=-& set ARGS=
      :: single-ampersand means execute second command regardless of EXITCODE from first command
    :next_arg
    if not defined ICN_FILE if not "%~ns1" == "-" if not exist "%~dpns1.icn" set ARGS=%ARGS% %ARG%
    if defined ICN_FILE if not defined JUST_DEFINED  set ARGS=%ARGS% %ARG%
    shift
    set FORCED_QUOTE_RESULT=ARG
    call :force_quote %1
    set FORCED_QUOTE_RESULT=ARG_no_x
    call :force_quote %~dpn1
    set ARG_x=%~x1
    if not defined ARG2 goto got_args
    goto more_args
:got_args


  set EXIT_ERROR=0
  if "%ICN_FILE%" == "-" goto have_pipe

:not_pipe
  :: set ICX=%ICNSRCdps%%ICNSRCns%.bat
  set ICX=%ICX_FILE%
  if not exist "%ICNSRCdpnsx%" if not exist "%ICNSRCdpns%.icn" (
    echo.icon.cmd: No .icn file find among args:
    echo.    %*
    goto usage_ERROR
  )
  if /I not "%ICNSRCdpnsx:~-4%" == ".icn" set ICNSRCdpnsx=%ICNSRCdpns%.icn
  if /I not "%ICNSRCdpnsx:~-4%" == ".icn" set ICNSRCdpnsx=%ICNSRCdpns%.icn
  if not exist "%ICNSRCdpnsx%" (
    echo.icon.cmd: No file ending in '.icn' find among args:
    echo.    %*
    goto usage_ERROR
  )
  set ICNSRCdpnsx="%ICNSRCdpnsx%"
  set ICX="%ICX%"
  (
    type %ICNSRCdpnsx% | call %ARG0%icont.cmd -o %ICX% -u -v0 %ICONT_ARGS% -
  ) && if exist %ICX% (
    call %ICX% %ARGS%
    del %ICX%
    if exist %ICX% echo icon.cmd: %ICX% still exists
  ) else (echo %ARG0%: translation of %ICNSRCdpnsx% FAILED)
  :: double-ampersand means execute second command only if first command returns zero EXITCODE

  @echo off
  goto post_pipe

:have_pipe
  set ICX=%ICNSRCdps%pipe%RANDOM%.bat
  set ICX="%ICX%"
  (
    call %ARG0%icont.cmd -o %ICX% -u -v0 %ICONT_ARGS% -
  ) && if exist %ICX% (
    call %ICX% %ARGS%
    del %ICX%
    if exist %ICX% echo icon.cmd: %ICX% still exists
  ) else (
    echo %ARG0%: translation of standard input FAILED
  )

:post_pipe
  set EXIT_ERROR=%ERRORLEVEL%
  if %EXIT_ERROR% == 0 exit /b 0
  echo exit code %EXIT_ERROR% 1>&2
  endlocal&exit /b %EXIT_ERROR%

:usage_ERROR
  set EXIT_ERROR=1

:usage
  echo.
  echo.usage: icon [options for icont] [program.icn or -] [args for program]
  echo.
  echo.For info regarding this build, see
  echo.  https://github.com/eschen42/portableIcon
  echo.
  echo.For info regarding the Icon programming language, see
  echo.  https://www.cs.arizona.edu/icon
  echo.
  endlocal&exit /b %EXIT_ERROR%

:: If you set FORCED_QUOTE_RESULT before calling this, that envar will be set
::   Before returning, FORCED_QUOTE_RESULT will be cleared
:force_quote
  set FORCED_QUOTE=%1
  :: echo force_quote:[%1]
  ::if defined FORCED_QUOTE echo is defined FORCED_QUOTE
  if not defined FORCED_QUOTE set FORCED_QUOTE=""
  :: force enclosing quotes
  if not %FORCED_QUOTE:~0,1%%FORCED_QUOTE:~-1,1% == "" set FORCED_QUOTE="%FORCED_QUOTE%"
  if not [%FORCED_QUOTE_RESULT%] == [] set %FORCED_QUOTE_RESULT%=%FORCED_QUOTE%
  set FORCED_QUOTE_RESULT=
  set FORCED_UNQUOTE=%FORCED_QUOTE:~1,-1%
  goto :eof
