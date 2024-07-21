@ECHO OFF
IF NOT "%1"=="" GOTO:%1



:Choice
REM :                                                                                                                        :
REM : Special thanks to Grub4K for the xcopy input method! (https://gist.github.com/Grub4K/2d3f5875c488164b44454cbf37deae80) :
REM :                                                                                                                        :

SETLOCAL ENABLEDELAYEDEXPANSION
SET "KEY="

::Set timeout if /t used
IF /I "%1."=="/T." START "CHOICE_AUTO_SKIP" /MIN CMD /C TIMEOUT /T %2^&TASKKILL /IM xcopy.exe /F

::Get user input - provided by Grub4K
FOR /F "DELIMS=" %%A IN ('XCOPY /W "!COMSPEC!" "!COMSPEC!" 2^>NUL ^|^| ECHO.TIMEOUT') DO (
	IF NOT DEFINED KEY SET "KEY=%%A^!"
)
IF !KEY:~-1!==^^ (
	::Escape the escape character, "caret"
	SET "KEY=CARET"
) ELSE IF "!KEY:~-2!"=="&^!" (
	::Escape the seperator character, "and"
	SET "KEY=AND"
) ELSE IF "!KEY:~-8,7!."=="TIMEOUT." (
	::If /T is used and times out, return it
	SET KEY=TIMEOUT
) ELSE (
	::Take out the key from the xcopy message
	SET "KEY=!KEY:~-2,1!"
)

IF /I "%1."=="/T." TASKKILL /FI "WINDOWTITLE eq CHOICE_AUTO_SKIP*" /IM cmd.exe 1>NUL
::Make key returns more understandable
IF NOT DEFINED KEY SET KEY=BLANK
IF "!KEY!"==" " SET KEY=SPACE
IF "!KEY!"=="	" SET KEY=TAB
IF "!KEY!"=="," SET KEY=COMMA
IF "!KEY!"=="=" SET KEY=EQUAL

::Pass the key variable outside the current local enviroment
ENDLOCAL&SET KEY=%KEY%
EXIT /B




REM :                                   :
REM : Below code was provided by T3RR0R :
REM :                                   :

:Create
Start /b /Wait "" "%~f0" Controller >.\tmp\signal.txt | "%~f0" Looper <.\tmp\signal.txt
EXIT /B 0

:Controller
SETLOCAL ENABLEDELAYEDEXPANSION
For /l %%e in ()Do (
	CALL :Choice
	<nul Set /P "=!KEY!"
)
:Looper
SETLOCAL ENABLEDELAYEDEXPANSION
For /L %%i in ()Do (
	Set /P "KEY="
	IF !KEY!.==!OKEY!. SET KEY=NUL&SET OKEY=NUL
	IF NOT !KEY!.==NUL. CALL "main.cmd" MAIN
	SET OKEY=!KEY!
)
