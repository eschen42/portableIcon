@set ERRORLEVEL=&setlocal&echo off
set ARG1=&set ARG1=%1
if not defined ARG1 goto :usage
set MYSRCDIR=
set MYBLDDIR="%~dp0"
set MYNTICONT="%~dp0nticont.exe"
set MYCD=%CD%
if "%ARG1%" == "-" (
  set MYSRCFILE=-
  set MYOFILE="%CD%\a.exe"
  
) else (
  set MYSRCDIR="%~dp1"
  set MYSRCFILE="%~dpn1.icn"
  set MYOFILE="%~dpn1.exe"
)
if not defined MYSRCDIR (
  if not defined IPATH set IPATH=%~dp0ipl
) else (
  if not defined IPATH set IPATH=%~dp0ipl %~dp1
)

if not defined MYSRCDIR goto :translating_stdin
  pushd %MYSRCDIR%
  %MYNTICONT% -c %MYSRCFILE%
  popd

:translating_stdin
pushd %MYBLDDIR%
nticont -o %MYOFILE% %2 %3 %4 %5 %6 %7 %8 %9 %MYSRCFILE%
popd

exit /b 0

:usage
echo usage: %~nx0 file [-cstuEIX] [-fs] [-e efile]
:: echo usage: icont [-cstuEIX] [-fs] [-e efile] [-o ofile] file
:: echo rather, that will be the usage once this script is fully implemented
echo You can find %~nx0 at %~dp0
