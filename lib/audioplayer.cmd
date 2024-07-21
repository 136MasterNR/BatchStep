@ECHO OFF
TITLE mpg123.%1
ECHO.mpg123.AudioPlayer.ID:"%1"
ECHO.Location:%2
ECHO.
ECHO.
SET PARAMETERS=%3
SET PARAMETERS=%PARAMETERS:"=%
CALL .\lib\binaries\mpg123.exe %PARAMETERS% --no-control --no-visual --resample fine %2 >NUL
EXIT 0
