IF NOT "%~1"=="" GOTO:%1


:SETUP DO NOT RUN BACKGROUND SCRIPTS HERE!!!
IF NOT EXIST .\tmp MD .\tmp

%_AUDIO.start:$=menu.mp3 title True 100%

%_ASSET.insert:$=menu\menu%

BREAK>.\tmp\ENGINE.draw

%_ENGINE.start% &:: Shouldn't run here permanently

CHOICE CREATE

EXIT /B 0


:MAIN

IF NOT DEFINED SETUP_RUN (SET SETUP_RUN=1
	%_ENGINE.stop%

	SET POS_Y=4
	SET POS_X=1
	SET TURN=right
	
	%_AUDIO.start:$=pressstart.mp3 sfx False 70%

	%_AUDIO.stop:$=title%
	
	%_ENGINE.start%
	%_SCRIPT.call:$=menufade%
	
	%_SCRIPT.child:$=level%

	REM %_SCRIPT.child:$=droplet%
	
	EXIT /B 0
)

IF %KEY%.==. EXIT /B 0
IF %KEY%==TIMEOUT EXIT /B 0

IF %KEY%== (
	%_ENGINE.stop%
	EXIT /B 0
)

IF /I %KEY%==A (
	%_SIGNAL.send:$=arrow_left%
)
IF /I %KEY%==S (
	%_SIGNAL.send:$=arrow_down%
)
IF /I %KEY%==W (
	%_SIGNAL.send:$=arrow_up%
)
IF /I %KEY%==D (
	%_SIGNAL.send:$=arrow_right%
)

IF /I %KEY%==Q (
	%_AUDIO.stop:$=track%
)



EXIT /B 0
