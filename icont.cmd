  @set ERRORLEVEL=&setlocal&set EXIT_CODE=1&set ECHO_ON=off
  @echo %ECHO_ON%

  :: At least one argument is required
  set ARG1=&set ARG1=%1&set ARG1s=%~dpns1
  if not defined ARG1 goto usage
  set EXIT_CODE=0
  set REQUEST_VERSION=0
  set DASH_C=0
  set DASH_E=0
  set DASH_O=
  if /I ""%1"" == ""--help"" goto help
  if    ""%1"" == ""/?""     goto help
  if /I ""%1"" == ""-H""     goto help
  set ARG2=%2
  if /I ""%1"" == ""-V""     if not defined ARG2 set REQUEST_VERSION=1

  :: set ARGS and STANDALONE
  call :get_args %*
  if "%DASH_O%%DASH_C%" == "11" (
    echo.%~nxs0: options `-o` and `-c` are incompatible
    echo.
    goto usage
  )

  :: *Before* changing to the directory with the translator,
  ::   set ME_FIRST to the current working directory.
  call :set_me_first "%CD%"
  :: Temporarily change to the directory having the translator, which is
  ::   the directory where this script lives.
  pushd "%~dps0"
  set BINDIR=%CD%\bin
  :: set full 8.3 path to interpreter
  set MYNTICONT="%BINDIR%\nticont.exe"
  :: Unless IPATH has already been set, link files either in working
  ::   directory or in ipl\procs
  if not defined IPATH set IPATH=%ME_FIRST% %~dps0ipl\procs
  :: Unless LPATH has already been set, set LPATH to taste
  :: if not defined LPATH set LPATH=%~dps0ipl\progs %~dps0ipl\procs
  if not defined LPATH set LPATH=%~dps0ipl\incl
  :: Return to working directory
  popd

  :: echo %MYNTICONT% %ARGS% %UCODES% 1>&2
  :: Pass all arguments to the translator
  %MYNTICONT% %ARGS% %UCODES%
  set MY_RESULT=%ERRORLEVEL%
  if "%DASH_C%" == "1" exit /b %MY_RESULT%
  if "%DASH_E%" == "1" exit /b %MY_RESULT%
  if "%REQUEST_VERSION%" == "1" exit /b 0
  if not %MY_RESULT% == 0 exit /b %MY_RESULT%

:shift_loop
    shift
    if NOT .%1. == .. goto shift_loop

  if ""%ISRC%"" == """-""" (
    set ICODE="stdin"
    set ICODEx=.exe
  )
  if not defined ICODE (
    set ICODE="%ISRC:~1,-1%"
    set ICODEx=.exe
  )
  :: smudge if icode.exe exists
  if not defined ICONT_NOSMUDGE if not exist "%ICODE:~1,-1%%ICODEx%" echo Does the directory for "%ICODE:~1,-1%%ICODEx%" exist?
  if not defined ICONT_NOSMUDGE if exist "%ICODE:~1,-1%%ICODEx%" (
    call "%BINDIR%\smudge.cmd" "%ICODE:~1,-1%%ICODEx%" %STANDALONE% %ADD_EXE%
  )
  :: Produce result returned by translator
  exit /b %MY_RESULT%

:set_me_first
  :: Set the ME_FIRST environment variable
  set ME_FIRST=%~dpns1
  exit /b 0

::::::::::::::::::::::::::: :get_args subroutine ::::::::::::::::::::::::::::
:get_args
:: shift to dispose of name of subroutine
shift
:: wipe ARGS and STANDALONE
set ARGS=
set STANDALONE=
set LAST_ARG=
set ICODE=
set UCODES=
set ISRC=
:: shift till last arg is %0
set ARG=%0
if not defined ARG goto got_args
  :more_args
    if ""-c"" == ""%ARG%"" set DASH_C=1
    if ""-E"" == ""%ARG%"" set DASH_E=1
    if not ""%ARG%"" == """%ARG:~1,-1%""" (
      if %ARG% == --standalone goto standalone
      if %ARG% == --add-exe goto add_exe
    )
    if not defined ISRC if exist "%~dpns0.icn" set ISRC="%~n0"
    set UCODE=""
    if "%~xs0" == ".u1"  set UCODE="%~nx0"
    if "%~xs0" == ".u2"  set UCODE="%~nx0"
    if not %UCODE% == "" (
      set UCODES=%UCODES% %UCODE%
    ) else (
      set ARGS=%ARGS% %ARG%
      set LAST_ARG=%0
    )
    goto shift_args
  :add_exe
    set ADD_EXE=--add-exe
    goto shift_args
  :standalone
    set STANDALONE=--standalone
    goto shift_args
  :shift_args
    shift
    set ARG=%0
    set ARGx=%~xs0
    if ""-o"" == ""%LAST_ARG%"" (
      set DASH_O=1
      set ICODE="%~dpn0"
      set ICODEx=%ARGx%
      if "%ARGx%" == "" (
        set ICODEx=.exe
        set ADD_EXE=--add-exe
      )
      if /i "%ARGx%" == ".exe" set ADD_EXE=--add-exe
      if /i "%ARGx%" == ".bat" set ARG=%~dpn0
    )
    if not defined ARG goto got_args
    goto more_args
:got_args
  :: Note this quirk: setting ICODEx to .exe does NOT result in
  ::   invocation of smudge with --add-exe, which is correct
  ::   but may be unexpected.
  if /i "%ICODEx%" == ".bat" set ICODEx=.exe
  @echo %ECHO_ON%
  :: @echo ARGS=%ARGS% 1>&2
  :: @echo UCODES=%UCODES% 1>&2
  :: @echo ISRC=%ISRC% 1>&2
  :: @echo ICODE=%ICODE% 1>&2
  :: @echo ICODEx=%ICODEx% 1>&2
  :: @echo STANDALONE=%STANDALONE% 1>&2
  :: @echo ADD_EXE=%ADD_EXE% 1>&2
goto :eof
::::::::::::::::::::::::::: :get_args subroutine ::::::::::::::::::::::::::::

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
# icont usage:
!NX0! [-cpstuEV] [-fs] [-o ofile] [--add-exe] [--standalone] file [files]
   where file(s) may have extensions `.icn`, `.u1`, or `.u2`; no extension
   implies `.icn`.

   -c   Perform no linking, just produce `.u1` and `.u2` files.
          - This is incompatible with `-o`.
   -fs  Prevent removal of all unreferenced declarations.
        This has the same effect as `invocable all` in the program.
   -o   Name for output file:
          - This is incompatible with `-c`.
          - If `-c` and `-o` are unspecified, `-o file.bat` is implied.
          - If `ofile` has extension `.exe`, `--add-exe` is implied.
   -p   enable icode profiling
   -s   Suppress informative messages.
   -t   Turn on procedure tracing.
   -u   Warn about undeclared IDs (strongly recommended).
   -v n Set verbosity of output, where:
          n = 0 - suppress non-error output [same as -s]
          n = 1 - list procedure names [the default]
          n = 2 - also report the sizes of icode sections
                  [procedures, strings, and so forth]
          n = 3 - also list discarded globals
   -E   Preprocess only (send preprocessing results to standard output and
        perform no subsequent steps. [This can be very helpful when debugging.]
          - This makes other options moot.
   -V   print version information
   --standalone
        Copy nticonx.exe and cygwin1.dll to directory having .bat file.
   --add-exe
        (Implied when ofile name ends with `.exe`)
        Create an `ofile.exe` file that invokes `ofile.bat`.
        This passes all arguments through, but it works only when
        `ofile.exe` and `ofile.bat` are in the same directory.

You can find !NX0! at !DPNX0!

Environmental variables recognized by !NX0!

Name     Description                             Effective Default
-----    ------------------------------------    -----------------
IPATH    search path for link directives         . %IPL%\procs
LPATH    search path for $include directives     . %IPL%\incl
IPL      root of the Icon Programming Library    not defined

Search paths are blank-separated lists of directories.
The current directory is always searched before a search path is used.
When the environment variable for the search path is undefined,
  the corresponding subdirectory of the ipl directory is also searched.
IPL is a "convenience variable" that is automatically set (only) by
  `conda activate icon` on Windows.
-------------------------------------------------------------------------------

:post_usage

exit /b %EXIT_CODE%
