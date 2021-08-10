  @set ERRORLEVEL=&setlocal&echo off
  :: At least one argument is required
  set ARG1=&set ARG1=%1&set ARG1s=%~dpns1
  set ARGS=%*
  if /I ""%1"" == ""--help"" goto usage
  if    ""%1"" == ""/?""     goto usage
  if /I ""%1"" == ""-H""     goto usage
  if not defined ARG1 goto usage

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
  if not defined LPATH set LPATH=%~dps0ipl\progs
  :: Return to working directory
  popd
  :: Pass all arguments to the translator
  %MYNTICONT% %*
  set MY_RESULT=%ERRORLEVEL%
  ::::obsolete :: Ensure that noop.bat exists in local directory when translation was
  ::::obsolete ::   successful.  Although this is not needed for .exe files, there is
  ::::obsolete ::   no easy way to tell whether a .exe or a .bat was produced.
  ::::obsolete if %MY_RESULT% neq 0 if not exist noop.bat (
  ::::obsolete   echo exit /b %%ERRORLEVEL%%> noop.bat
  ::::obsolete )
:shift_loop
    shift
    if NOT .%1. == .. goto shift_loop

  if exist %~dpns0.exe (
    call "%BINDIR%\smudge.cmd" %~dpns0.exe >NUL
  )
  :: Produce result returned by translator
  exit /b %MY_RESULT%

:set_me_first
  :: Set the ME_FIRST environment variable
  set ME_FIRST=%~dpns1
  exit /b 0

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

  if defined ARG1 echo %~nxs0 %*
  set NX0=%~nx0
  set DP0=%~dp0
  set DPNX0=%~dpnx0
  call :heredoc :post_usage & goto :post_usage


usage: !NX0! [-cpstuEV] [-fs] [-e efile] [-o ofile] file
   -c   Perform no linking, just produce `.u1` and `.u2` files.
   -e   Redirect standard error [for execution] to efile.
   -fs  Prevent removal of all unreferenced declarations.
        This has the same effect as "invocable all" in the program.
   -o   Name for output file.  Without -o, !NX0! defaults creates
          file.bat
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
   -E   Preprocess only. [This can be very helpful when debugging.]
   -V   print version information
 
When !NX0! creates an .exe file:
   - It is likely that:
     + either, you will want to invoke the interpreter directly with
         !DP0!iconx.cmd file.exe
     + or you may want to run
         !DP0!bin\smudge.cmd file.exe
       to produce file.bat, but remember to 
         call file.bat
       from batch files so that control will return to the calling
       script when file.bat exits.
 
You can find !NX0! at !DPNX0!

:post_usage
