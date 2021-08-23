@set ERRORLEVEL=&setlocal&set ECHO_ON=off
@echo %ECHO_ON%
call %~dps0smoke_test.cmd > %~dps0smoke_test.output.actual.txt
if %ERRORLEVEL% neq 0 (
  (echo Smoke test FAILED with error %ERRORLEVEL%)
  endlocal
  exit/b %ERRORLEVEL% 
)
diff %~dps0smoke_test.output.expected.txt %~dps0smoke_test.output.actual.txt
if %ERRORLEVEL% neq 0 (
  (echo Smoke test FAILED because results differed from what was expected)
  endlocal
  exit/b %ERRORLEVEL% 
)
echo.Smoke test was SUCCESSFUL.
endlocal&exit /b 0
