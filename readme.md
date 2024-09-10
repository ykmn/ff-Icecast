# ff-Icecast

![Windows Batch](https://img.shields.io/badge/Windows%20Batch-%23909090.svg?style=for-the-badge&logo=Windows&logoColor=white)
[![Licence](https://img.shields.io/github/license/ykmn/ff-Logger?style=for-the-badge)](./LICENSE)
![Microsoft Windows](https://img.shields.io/badge/Microsoft-Windows-%FF5F91FF.svg?style=for-the-badge&logo=Microsoft%20Windows&logoColor=white)


* ff-Icecast.bat: Простой source-клиент с функцией watchdog, позволяющий отправить звук с аудиовхода на сервер Icecast.

* ff-Run.bat: Скрипт для одновременного запуска нескольких стримов на разные серверы.


## Использование:

### ff-Run

В файле `ff-Run.bat` необходимо в нужном количестве указать параметры подключения:

```
set server=source.hvostingradio.ru:8000
set stream=test1.mp3
set pass=pa55wr0d
set device="audio=@device_cm_{33D9A762-90C8-11D0-BD43-00A0C911CE86}\wave_{A8FB9BC3-1757-48D7-A74B-2ED433809457}"
start "%stream% Watchdog" ff-icecast.bat %server% %stream% %pass% %device%
```

* `server=` адрес сервера и порт

* `stream=` название маунта

* `pass=` пароль для source

* `device=` название устройства DirectShow с функцией аудиовхода. Для определения названия устройства DirectShow необходимо выполнить команду `ffmpeg.exe -list_devices true -f dshow -i dummy` и найти для выбранного аудиоустройства строку вида `"audio=@device_cm_{33D9A762-90C8-11D0-BD43-00A0C911CE86}\wave_{A8FB9BC3-1757-48D7-A74B-2ED433809457}"`. Обратите внимание, что строка должна быть в кавычках. 


### ff-Icecast

Приложение-watchdog, запускающее дочерний процесс с ffmpeg и перезапускающее его через 3 секунды при выходе или аварийном завершении.
Путь к ffmpeg должен быть добавлен в PATH.

Логи ffmpeg (уровень 24, предупреждения) пишутся в .\LOG\названиемаунта

Логи старше 30 дней удаляются при запуске скрипта.

## История версий:
* 2023-12-14 - v1.00 Начальная версия
