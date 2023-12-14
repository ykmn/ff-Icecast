@echo off
cd /d "%~dp0"
::    %1           %2      %3      %4
:: %server:port% %mount% %pass% %device%
echo [93m*   ff-Icecast.bat[0m v1.00 2023-12-14 Roman Ermakov r.ermakov@emg.fm
echo Simple Icecast source client for ffmpeg and audio input.
echo You need ffmpeg.exe to be available on the PATH.
if "%1" neq "" goto:stream
echo.
echo Usage: ff-Icecast [server:port] [mountname] [password] ["device"]
echo All parameters are manadatory.
echo.
echo Example:
echo ff-Icecast webradio.ru:8000 mystream.mp3 5tr0n9pa55w0RD "@device_cm_{33D9A762-90C8-11D0-BD43-00A0C911CE86}\wave_{F84408DF-9C57-4C98-A66F-FBCC9EA194DD}"
echo.
echo You should find DirectShow device name by executing:
echo     ffmpeg.exe -list_devices true -f dshow -i dummy
echo The string "@device_cm_{33D9A762-90C8-11D0-BD43-00A0C911CE86}\wave_{F84408DF-9C57-4C98-A66F-FBCC9EA194DD}"
echo is the device name for "Stereo Mix (Realtek(R) Audio) (audio)" device.
goto:eof

:stream
if not exist LOG\%2\. mkdir LOG\%2
echo [93m* Purging logs older than 30 days
forfiles /p "log" /s /d -30 /c "cmd /c del @file" > nul

:loop
echo.
echo [92m* Streaming %2 to Icecast server %1 [0m

set YEAR=%DATE:~-4%
set MONTH=%DATE:~3,2%
if "%MONTH:~0,1%" == " " set MONTH=0%MONTH:~1,1%
set DAY=%DATE:~0,2%
if "%DAY:~0,1%" == " " set DAY=0%DAY:~1,1%
set HOUR=%TIME:~0,2%
if "%HOUR:~0,1%" == " " set HOUR=0%HOUR:~1,1%
set MINS=%TIME:~3,2%
set SECS=%TIME:~6,2%

set FFREPORT=file=log/%2/ff.%2.%YEAR%%MONTH%%DAY%-%HOUR%%MINS%%SECS%.log:level=24
::set FFREPORT=file=ffreport.log:level=24
:: ‘quiet, -8’ ‘panic, 0’ ‘fatal, 8’ ‘error, 16’ ‘warning, 24’ ‘info, 32’ ‘verbose, 40’ ‘debug, 48’
:: Input device on Windows, you should find DShow device name by:
::   ffmpeg.exe -list_devices true -f dshow -i dummy

start "Streamer for %1" /wait ^
ffmpeg.exe -f "DShow" ^
 -i %4 ^
 -ar 44100 ^
 -ac 2 ^
 -ab 320k ^
 -c:a libmp3lame ^
 -vn -f mp3 ^
 -content_type 'audio/mpeg' ^
icecast://source:%3@%1/%2

echo [91m* %YEAR%.%MONTH%.%DAY% %TIME% Watchdog is restarting %2 stream in 3 seconds. [0m
choice /t 3 /c yq /CS /D y /M "Press y to continue, q to cancel:"
if %ERRORLEVEL% neq 1 ( exit ) else ( goto:loop )
exit
