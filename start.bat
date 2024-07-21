:: :::::::::: ::
:: DOS Config ::
@PUSHD "%~dp0"
@VERIFY OFF
@ECHO OFF&:: Disable Command Debug Outputs
@ECHO.[?25l&:: Disable Cursor
@COLOR 0F&:: Default Color Rendering
@PROMPT $^>&:: Prompt Style

ECHO.Starting engine...

:: System Variables ::
FOR /F "delims==" %%I IN ('SET ^| FINDSTR /I /V
	/C:"PROMPT"
	/C:"PSModulePath"
	/C:"USERDOMAIN"
	/C:"SystemRoot"
	/C:"HOMEPATH"
	/C:"HOMEDRIVE"
	/C:"ComSpec"
	/C:"COMPUTERNAME"
	/C:"USERNAME"
	/C:"SystemDrive"
') DO SET "%%I="

:: Library References ::
SET "Path=%~dp0lib;%~dp0script;%SystemRoot%\system32"
SET "PATHEXT=.EXE;.BAT;.CMD;.COM;.VBS;.VBE"

:: Global Variables ::
SET "TMP=%~dp0\tmp"
SET "TEMP=%~dp0\tmp"
SET LINES=32&:: Required Lines to Render - DEFAULT: 30
SET COLS=78&:: Maximum Amount of Columns - DEFAULT: 122
REM Real Size: 78x64

:: Window Config ::
CHCP 65001 >NUL&:: Text Encoding
TITLE &:: Window Title
MODE CON:COLS=%COLS% LINES=%LINES%

ECHO.Starting engine...

:: Macro Commands / Modules ::
SET _ENGINE.start=START /B "" CMD /Q /C engine 2^>NUL
SET _ENGINE.stop=BREAK^>"%TMP%\ENGINE.stop"^&HELP^>NUL^&HELP^>NUL^&HELP^>NUL
SET _ASSET.insert=CALL asset insert $
SET _ASSET.update=CALL asset update $
SET _ASSET.switch=CALL asset switch $
SET _ASSET.remove=CALL asset remove $
SET _ASSET.removeall=CALL asset removeall
SET _SIGNAL.send=IF NOT EXIST "%TMP%\$.sig" BREAK^>"%TMP%\$.sig"
SET _SIGNAL.exist=IF EXIST "%TMP%\$.sig"
SET _SIGNAL.nexist=IF NOT EXIST "%TMP%\$.sig"
SET _SIGNAL.recieve=IF EXIST "%TMP%\$.sig" DEL /Q "%TMP%\$.sig"2^>NUL^&
SET _SIGNAL.remove=DEL /Q "%TMP%\$.sig"
SET _CTRL.input=CALL choice
SET _CTRL.delay=TIMEOUT /T $ /NOBREAK ^>NUL
SET _SCRIPT.child=START /B "" CMD /Q /C $
SET _SCRIPT.call=CALL $
SET _SCENE.start=CALL .\scenes\$.cmd
SET _AUDIO.start=START /B "" CMD /C CALL audiomanager START $ ^^^& EXIT 2^>^&1
SET _AUDIO.stop=START /B "" CMD /C CALL audiomanager STOP $ ^^^& EXIT 2^>^&1
SET _WINDOW.subtitle=TITLE %TITLE%$
SET _WINDOW.cols=SET COLS=$^&MODE CON:COLS=$
SET _WINDOW.lines=SET LINES=$^&MODE CON:LINES=$
SET _CON.print_arr=CALL print array "


:: ::::: ::
:: Start ::
>NUL 2>&1 RD /S /Q ".\tmp"
CALL ".\main.cmd"

>NUL 2>&1 DEL /Q ".\tmp\ENGINE.stop"
EXIT /B 0
:: Stop ::
:: :::: ::