@echo off
:: Input device on Windows, you should find DShow device name by:
::   ffmpeg.exe -list_devices true -f dshow -i dummy
cd /d "%~dp0"

echo [93m*   ff-Run.bat[0m v1.00 2023-12-14 Roman Ermakov r.ermakov@emg.fm
echo Script for batch running ff-Icecast clients.


set server=source.hvostingradio.ru:8000
set stream=test1.mp3
set pass=pa55wr0d
set device="audio=@device_cm_{33D9A762-90C8-11D0-BD43-00A0C911CE86}\wave_{A8FB9BC3-1757-48D7-A74B-2ED433809457}"
call:callStreamer

set server=source.hvostingradio.ru:8001
set stream=test2.mp3
set pass=pa55wr0d
set device="audio=@device_cm_{33D9A762-90C8-11D0-BD43-00A0C911CE86}\wave_{A8FB9BC3-1757-48D7-A74B-2ED433809457}"
call:callStreamer

goto:eof
:callStreamer
start "%stream% Watchdog" ff-icecast.bat %server% %stream% %pass% %device%
exit /b