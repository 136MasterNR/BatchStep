GOTO :_%1
EXIT /B 0

:_update
SETLOCAL ENABLEDELAYEDEXPANSION
FOR /F "USEBACKQ TOKENS=1,2DELIMS=#" %%1 IN ('%2') DO (
	SET FILE=%%1
	SET SUFFIX=%%2
)
IF DEFINED SUFFIX SET SUFFIX=#!SUFFIX!
SET LAYER=!ASSET[%2].layer!

FOR /F "TOKENS=1,2*DELIMS==" %%1 IN (.\assets\!FILE!.ans) DO (
	FOR /F "TOKENS=1DELIMS=[]" %%A IN ("%%1") DO SET /A CALC=%%A
	ECHO SET map[!LAYER!.!CALC!]=%%2>>".\tmp\buffer_layer_!LAYER!.asset"
)

:update-RETRY
MOVE /Y ".\tmp\buffer_layer_!LAYER!.asset" ".\tmp\buffer_layer_!LAYER!.cmd" 2>NUL 1>NUL || GOTO :update-RETRY

ENDLOCAL&SET ASSET[%FILE%%SUFFIX%].layer=%LAYER%
EXIT /B 0


:_insert
SETLOCAL ENABLEDELAYEDEXPANSION
FOR /F "USEBACKQ TOKENS=1,2DELIMS=#" %%1 IN ('%2') DO (
	SET FILE=%%1
	SET SUFFIX=%%2
)
IF DEFINED SUFFIX SET SUFFIX=#!SUFFIX!
SET LAYER=0

:INSERT-CNT
SET /A LAYER+=1
IF EXIST .\tmp\layers FOR /F "DELIMS=" %%I IN (.\tmp\layers) DO (
	IF %%I EQU !LAYER! GOTO :INSERT-CNT
	IF %%I GTR !LAYER! GOTO :INSERT-SKIP
)
:INSERT-SKIP

BREAK>.\tmp\buffer_layer_!LAYER!.cmd
FOR /F "TOKENS=1,2*DELIMS==" %%1 IN (.\assets\!FILE!.ans) DO (
	FOR /F "TOKENS=1DELIMS=[]" %%A IN ("%%1") DO SET /A CALC=%%A
	ECHO SET map[!LAYER!.!CALC!]=%%2>>".\tmp\buffer_layer_!LAYER!.cmd"
)
ECHO.!LAYER!>>.\tmp\layers
SORT .\tmp\layers 1>.\tmp\layerss
MOVE .\tmp\layerss .\tmp\layers 1>NUL

ENDLOCAL&SET ASSET[%FILE%%SUFFIX%].layer=%LAYER%
EXIT /B 0


:_switch
SETLOCAL ENABLEDELAYEDEXPANSION
FOR /F "USEBACKQ TOKENS=1,2DELIMS=#" %%1 IN ('%3') DO (
	SET FILE=%%1
	SET SUFFIX=%%2
)
IF DEFINED SUFFIX SET SUFFIX=#!SUFFIX!
SET LAYER=!ASSET[%2].layer!

BREAK>.\tmp\buffer_layer_!LAYER!.asset 2>NUL
FOR /F "TOKENS=1,2*DELIMS==" %%1 IN (.\assets\!FILE!.ans) DO (
	FOR /F "TOKENS=1DELIMS=[]" %%A IN ("%%1") DO SET /A CALC=%%A
	ECHO SET map[!LAYER!.!CALC!]=%%2>>".\tmp\buffer_layer_!LAYER!.asset"
)

:switch-RETRY
MOVE /Y ".\tmp\buffer_layer_!LAYER!.asset" ".\tmp\buffer_layer_!LAYER!.cmd" 2>NUL 1>NUL || GOTO :switch-RETRY

ENDLOCAL
EXIT /B 0


:_remove
SET LAYER=!ASSET[%2].layer!

DEL /Q ".\tmp\buffer_layer_!LAYER!.cmd" || GOTO :_remove
SET ASSET[%2].layer=

BREAK>.\tmp\layerss

FOR /F "TOKENS=1,*DELIMS==" %%1 IN ('SET ASSET[ 2^>NUL') DO (
	IF %%2 NEQ !ASSET[%2].layer! 1>>.\tmp\layerss ECHO.%%2
)

SORT .\tmp\layerss 1>.\tmp\layersss
DEL /Q .\tmp\layerss
:remove_retry
MOVE .\tmp\layersss .\tmp\layers 1>NUL || GOTO :remove_retry

EXIT /B 0


:_removeall
SETLOCAL ENABLEDELAYEDEXPANSION

BREAK>.\tmp\layers

HELP>NUL
HELP>NUL
HELP>NUL
HELP>NUL
HELP>NUL
HELP>NUL
HELP>NUL

FOR /F "TOKENS=1DELIMS==" %%I IN ('SET ASSET[') DO SET %%I=
RD /Q .\tmp /S
MD .\tmp

ENDLOCAL
EXIT /B 0