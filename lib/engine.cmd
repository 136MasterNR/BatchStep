SET /A TMP=0,CNT=0,MAX=0
IF EXIST .\tmp\ENGINE.stop DEL /Q ".\tmp\ENGINE.stop"
:RENDER

IF NOT EXIST .\tmp\layers GOTO :RENDER

IF EXIST .\tmp\ENGINE.stop DEL /Q ".\tmp\ENGINE.stop"&TITLE &EXIT

IF NOT EXIST .\tmp\ENGINE.drawrapid IF EXIST .\tmp\ENGINE.draw (DEL /Q .\tmp\ENGINE.draw) ELSE GOTO :RENDER

:: Buffer optimization
SETLOCAL ENABLEDELAYEDEXPANSION

:PULL-RETRY
SET RETRY=
FOR /F "DELIMS=" %%I IN (.\tmp\layers) DO (
	CALL ".\tmp\buffer_layer_%%I.cmd" 2>NUL || SET RETRY=%%I
)

:RENDER-RETRY
IF EXIST ".\tmp\buffer_layer_!RETRY!.cmd" IF DEFINED RETRY CALL ".\tmp\buffer_layer_!RETRY!.cmd" || GOTO :RENDER-RETRY

:: For each line display all layers linked to it
FOR /L %%y IN (1, 1, %LINES%) DO FOR /F "DELIMS=" %%l IN (.\tmp\layers) DO IF DEFINED map[%%l.%%y] ECHO.[%%yH!map[%%l.%%y]![H

:: Clear buffer
ENDLOCAL

:: End of rendering, loop
GOTO :RENDER
