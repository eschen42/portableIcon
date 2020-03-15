@set ERRORLEVEL=&setlocal&echo off
set ARG1=&set ARG1=%1
set ARG2=&set ARG2=%2
set MYRESULT=87
if not defined ARG1 goto :usage

set MYSRCDIR=
set MYBLDDIR="%~dp0"
set MYNTICONT="%~dp0nticont.exe"
set MYCD=%CD%

if defined ARG2 (
  if not defined IPATH set IPATH=%~dp0ipl
  goto :translating_stdin
)
set MYSRCDIR="%~dp1"
set MYSRCFILE="%~dpn1.icn"
set MYOFILE="%~dpn1.exe"
if not defined IPATH set IPATH=%~dp0ipl %~dp1

pushd %MYSRCDIR%
%MYNTICONT% -c %MYSRCFILE%
set MYRESULT=%ERRORLEVEL%
popd
if %MYRESULT% neq 0 goto :usage

:translating_stdin

pushd %MYBLDDIR%
if     defined MYOFILE %MYNTICONT% -u -o %MYOFILE% %MYSRCFILE%
if not defined MYOFILE %MYNTICONT% %*
set MYRESULT=%ERRORLEVEL%
popd
if %MYRESULT% neq 0 goto :usage

exit /b 0

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
