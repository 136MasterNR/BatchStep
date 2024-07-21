GOTO :_%1
EXIT /B 0

:_array
SET ARG=%2
SET ARG=%ARG:~3%
> CON ECHO.%ARG:;=[1B[G%
EXIT /B 0
