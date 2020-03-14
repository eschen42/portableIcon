@set ERRORLEVEL=&setlocal&echo off
set ARG1=&set ARG1=%1
if not defined ARG1 goto :usage
set MYBLDDIR="%~dp0"
set MYNTICONT="%~dp0nticont.exe"
set MYSRCDIR="%~dp1"
set MYSRCFILE="%~dpn1.icn"
set MYOFILE="%~dpn1.exe"
if not defined IPATH set IPATH=%~dp0ipl %~dp1 %~dp1

pushd %MYSRCDIR%
%MYNTICONT% -c %MYSRCFILE%
popd

pushd %MYBLDDIR%
nticont -o %MYOFILE% %MYSRCFILE%
popd

exit /b 0

:usage
echo usage: icont [-cstuEIX] [-fs] [-e efile] [-o ofile] file
echo rather, that will be the usage once this script is fully implemented
