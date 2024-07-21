@ECHO OFF
CALL :%* 2>NUL || FOR /F "TOKENS=1,2DELIMS==" %%A IN ('SET') DO (
	ECHO.%%A[0m=%%B[0m <NUL > CON
)
@EXIT /B 0

:SIZE
SET>".\memory_out.dmp"
FOR %%A IN (".\memory_out.dmp") DO ECHO Memory usage is at %%~ZA bytes.
DEL /Q ".\memory_out.dmp"
EXIT /B 0

:CLEAR
IF /I %1.==ALL. (
	FOR /F "TOKENS=1DELIMS==" %%A IN ('SET') DO SET "%%A="
)
EXIT /B 0

:GC
IF /I %1.==CLEAR. (
	FOR /F "TOKENS=1DELIMS==" %%A IN ('SET TMP.^&SET TEMP.^&SET TMP_^&SET TEMP_^&SET VAR^&SET ARG') DO @SET %%A=
	ECHO.Unused variables have been removed.
	SAVE
) ELSE (
	SET TMP | FINDSTR /V "Local\Temp"
	SET TEMP | FINDSTR /V "Local\Temp"
	SET VAR.
	SET CRAFT.UI
	IF DEFINED ARG ECHO.ARG=%ARG%
)
EXIT /B 0
