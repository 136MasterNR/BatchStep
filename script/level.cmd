SETLOCAL ENABLEDELAYEDEXPANSION

SET OBJCNT=0

SET MACRO_SPAWNER=

SET $.CNT=0
FOR /F "USEBACKQ TOKENS=1,2 DELIMS=," %%1 IN (".\level.txt") DO (
	SET /A $.CNT+=1
	SET MACRO_SPAWNER=!MACRO_SPAWNER!%%1$%%2;
)

%_ASSET.switch:$=menu\menu level\screenarrows%

%_AUDIO.start:$=tracks\ZZZ.mp3 track False 100%

BREAK>.\tmp\ENGINE.draw

:: start delta time ::
for /f "tokens=1-4 delims=:.," %%a in ("!time: =0!") do set /a "t1=((((1%%a-1000)*60+(1%%b-1000))*60+(1%%c-1000))*100)+(1%%d-1000)"

:L
:: Delta Time Delay ::
:TIMEL
for /f "tokens=1-4 delims=:.," %%a in ("!time: =0!") do set /a "t2=((((1%%a-1000)*60+(1%%b-1000))*60+(1%%c-1000))*100)+(1%%d-1000)"
set /a "deltaTime=(t2 - t1)"
if defined odeltaTime (set /a "timePassed=deltaTime-odeltaTime") else set /a "odeltaTime=(t2 - t1)
::title centiseconds: !timePassed!
IF !timePassed! LSS 0 GOTO :TIMEL
set /a "odeltaTime=(t2 - t1)"


FOR /F "USEBACKQ TOKENS=1,2,3,4,*DELIMS=$;" %%1 IN ('!MACRO_SPAWNER!') DO (
	IF !deltaTime! GEQ %%1 (
		CALL :SPAWN %%2
		SET MACRO_SPAWNER=%%3$%%4;%%5
		IF NOT %%3.==. IF !deltaTime! GEQ %%3 (
			CALL :SPAWN %%4
			SET MACRO_SPAWNER=%%5
		)
	)
)

(
SET arrow_up_FIRST=
SET arrow_down_FIRST=
SET arrow_left_FIRST=
SET arrow_right_FIRST=
)
FOR /F "TOKENS=1,2,*DELIMS=[]=" %%1 IN ('2^>NUL SET OBJ[ ^| SORT') DO (
	SET $.ARROW=%%3
	SET $.ID=%%2
	SET /A $.POSY=OBJ.y[!$.ID!]
	SET /A $.POSX=OBJ.x[!$.ID!]

	IF !$.POSY! GEQ %LINES% (
		%_ASSET.remove:$=level\!$.ARROW!#!$.ID!%
		SET OBJ.y[!$.ID!]=
		SET OBJ.x[!$.ID!]=
		SET OBJ[!$.ID!]=

	) ELSE %_SIGNAL.nexist:$=!$.ARROW!% (
		SET /A OBJ.y[!$.ID!]+=1
		%_ASSET.update:$=level\!$.ARROW!#!$.ID!%

	) ELSE IF NOT DEFINED !$.ARROW!_FIRST ( %_SIGNAL.recieve:$=!$.ARROW!% (
		%_ASSET.remove:$=level\!$.ARROW!#!$.ID!%
		SET OBJ.y[!$.ID!]=
		SET OBJ.x[!$.ID!]=
		SET OBJ[!$.ID!]=
	)) ELSE (
		SET /A OBJ.y[!$.ID!]+=1
		%_ASSET.update:$=level\!$.ARROW!#!$.ID!%
	)

	SET !$.ARROW!_FIRST=1
)


BREAK>.\tmp\ENGINE.draw

GOTO :L

:SPAWN

SET /A OBJCNT+=1
IF !OBJCNT! LEQ 9 (SET $.ID=00!OBJCNT!
) ELSE SET $.ID=0!OBJCNT!

SET "OBJ[!$.ID!]=%1"

SET $.ARROW=%1

SET OBJ.y[!$.ID!]=-2

IF !$.ARROW!==arrow_left (
	SET OBJ.x[!$.ID!]=17
) ELSE IF !$.ARROW!==arrow_up (
	SET OBJ.x[!$.ID!]=30
) ELSE IF !$.ARROW!==arrow_down (
	SET OBJ.x[!$.ID!]=41
) ELSE IF !$.ARROW!==arrow_right (
	SET OBJ.x[!$.ID!]=53
)

SET /A $.POSY=OBJ.y[!$.ID!]
SET /A $.POSX=OBJ.x[!$.ID!]


%_ASSET.insert:$=level\!$.ARROW!#!$.ID!%

EXIT /B 0
