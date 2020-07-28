@set ERRORLEVEL=&setlocal&echo off
:: At least one argument is required
set ARG1=&set ARG1=%1
if not defined ARG1 goto :usage
  :: The -I argument on antique Icon 9.3.2 for Windows [tmain.c line 648]
  ::   means to produce icode rather than an executable.
  echo %* | findstr /c:"-I" >NUL && set ICONT_NOPATH=TRUE
  :: *Before* changing to the directory with the translator,
  ::   set ME_FIRST to the current working directory.
  call :set_me_first "%CD%"
  :: Temporarily change to the directory having the translator, which is
  ::   the directory where this script lives.
  pushd "%~dps0"
  :: Unless either the '-I' option was supplied or the ICONT_NOPATH
  ::   environment variable was set, put the directory having the translator
  ::   on the path; since that directory also has the interpreter, the
  ::   interpreter will be built into the executable.
  if not defined ICONT_NOPATH set PATH=%CD%;%PATH%
  :: set full 8.3 path to interpreter
  set MYNTICONT="%~dps0nticont.exe"
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
  :: Ensure that noop.bat exists in local directory when translation was
  ::   successful.  Although this is not needed for .exe files, there is
  ::   no easy way to tell whether a .exe or a .bat was produced.
  if %MY_RESULT% neq 0 if not exist noop.bat (
    echo exit /b %%ERRORLEVEL%%> noop.bat
  )
  :: Produce result returned by translator
  exit /b %MY_RESULT%

:set_me_first
  :: Set the ME_FIRST environment variable
  set ME_FIRST=%~dpns1
  exit /b 0

:usage

if defined ARG1 echo %~nxs0 %*
echo .
echo usage: %~nxs0 [-cstuEIX] [-fs] [-e efile] [-o ofile] file
echo ^  -c   Perform no linking, just produce `.u1` and `.u2` files.
echo ^  -e   Redirect standard error [for translation] to efile.
echo ^  -fs  Prevent removal of all unreferenced declarations.
echo ^       This has the same effect as "invocable all" in the program.
echo ^  -o   Name for output file.  Without -o, ofile defaults to:
echo ^         file.bat when the -I option is supplied or
echo ^                    or the ICONT_NOPATH environment variable is set
echo ^         file.exe otherwise
echo ^  -s   Suppress informative messages.
echo ^  -t   Turn on procedure tracing.
echo ^  -u   Warn about undeclared IDs (strongly recommended).
echo ^  -v n Set verbosity of output, where:
echo ^         n = 0 - suppress non-error output [same as -s]
echo ^         n = 1 - list procedure names [the default]
echo ^         n = 2 - also report the sizes of icode sections
echo ^                 [procedures, strings, and so forth]
echo ^         n = 3 - also list discarded globals
echo ^  -E   Preprocess only. [This can be very helpful when debugging.]
echo ^  -I   Create a .bat file [with icode only] rather than a .exe
echo ^         When the -o option value ends with ".bat", the -I argument
echo ^         is implicit, resulting in a .bat file with icode but no
echo ^         interpreter.
echo .
echo When %~nxs0 creates a .bat file:
echo ^  - It is likely that:
echo ^    + either, you will want to invoke the interpreter directly with
echo ^        %~dps0nticonx.exe file.bat
echo ^    + or you may want to put noop.bat on your path or run
echo ^        %~dps0smudge_nopath.cmd file.bat
echo ^      to reduce the chance of accidental termination of command scripts
echo ^      that invoke file.bat.
echo ^  - It is important for scripts that invoke file.bat to use:
echo ^      call file.bat
echo ^    so that control will return to the script when file.bat exits.
echo .
echo You can find %~nxs0 at %~dpnxs0
