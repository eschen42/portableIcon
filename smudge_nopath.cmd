@set ERRORLEVEL=&setlocal&echo off
set ARG1=%~dpns1
set ARG2=%2
if     defined ARG2     goto :usage
if not defined ARG1     goto :usage
if not exist %ARG1%.bat goto :usage
echo @echo off> smudge
echo %~dps0nticonx %%0 %%*>> smudge
:: You can un-comment out the echo line if you run your programs by
::   double-cliking and don't want the window to close immedately
::   after the program finishes.
:: echo pause>> smudge
echo exit /b %%ERRORLEVEL%%>> smudge
move /y %ARG1%.bat %ARG1%.smudge
copy smudge+%ARG1%.smudge %ARG1%.bat
del  smudge %ARG1%.smudge
exit/b 0

:usage

echo "usage: %~nx0 <icode.bat>"
exit /b 1
