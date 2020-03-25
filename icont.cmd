@set ERRORLEVEL=&setlocal&echo off
set ARG1=&set ARG1=%1
if not defined ARG1 goto :usage
  pushd "%~dp0"
  set PATH=%CD%;%PATH%
  set MYNTICONT="%~dp0nticont.exe"
  if not defined IPATH set IPATH=%~dp0ipl
  popd
  %MYNTICONT% %*
  exit /b %ERRORLEVEL%

:usage

if defined ARG1 echo %~nx0 %*
echo .
echo usage 1: %~nx0 file[.icn]
echo ^  This is equivalent to %~nx0 -u -o file.exe file[.icn]
echo .
echo usage 2: %~nx0      [-cstuEIX] [-fs] [-e efile] [-o ofile] file
echo ^  -c   Perform no linking, just produce `.u1` and `.u2` files.
echo ^  -fs  Prevent removal of all unreferenced declarations.
echo ^       This has the same effect as "invocable all" in the program.
echo ^  -s   Suppress informative messages.
echo ^  -t   Turn on procedure tracing.
echo ^  -u   Warn about undeclared IDs (strongly recommended).
echo ^  -v n Set verbosity of output, where n = 
echo ^         n = 0 - suppress non-error output [same as -s]
echo ^         n = 1 - list procedure names [the default]
echo ^         n = 2 - also report the sizes of icode sections
echo ^                 [procedures, strings, and so forth]
echo ^         n = 3 - also list discarded globals
echo ^  -E   Preprocess only. [This can be very helpful when debugging.]
echo .
echo You can find %~nx0 at %~dp0
