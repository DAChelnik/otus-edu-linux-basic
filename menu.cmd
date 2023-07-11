@echo off
mode con:cols=100
cd /d %~dp0

cls
ECHO.
call :colored "ТЕКУЩЕЕ СОСТОЯНИЕ ВИРТУАЛЬНЫХ МАШИН:" yellow
ECHO.
vagrant status
ECHO.

:start
ECHO.
call :colored "ОСНОВНОЕ МЕНЮ:" yellow
ECHO.
ECHO        0 - Статус виртуальных машин
ECHO        1 - Обновить контейнеры Vagrant
ECHO        2 -
ECHO.
ECHO        3 - Запустить все виртуальные машины
ECHO        4 -
ECHO        5 -
ECHO        6 - Отправить все виртуальные машины в сон (аналог VirtualBox - сохранить состояние)
ECHO        7 -   .. из сна
ECHO.
ECHO        8 - Удалить полностью все виртуальные машины
ECHO        9 - Сохранить виртуальные машины и перезагрузить сервер
ECHO.
ECHO.
call :colored "ВИРТУАЛЬНЫЕ МАШИНЫ:" yellow
ECHO.
ECHO        nlb				- Центр загрузок и зеркало репозиториев Ubuntu
ECHO        ns				- Сервер мониторинга IT-инфраструктуры, аудита и авторизации
ECHO        mysql-master	- MySQL сервер баз данных
ECHO        mysql-slave	- MySQL сервер баз данных
ECHO        prod-primary	- Production-окружение Веб сервер Nginx+Apache (master)
ECHO        prod-secondary	- Production-окружение Веб сервер Nginx+Apache (secondary)
ECHO        prod-backup		- Production-окружение Веб сервер Nginx+Apache (backup)
ECHO        build			- Сервер непрерывной интеграции (билд-сервер)
ECHO       	dev				- Сервер разработки приложений
ECHO.
ECHO.
call :colored "Введите код желаемого пункта" yellow
set /p choice=        : 


if '%choice%'=='0' goto status
if '%choice%'=='1' goto 1
if '%choice%'=='2' goto 2
if '%choice%'=='3' goto 3
if '%choice%'=='4' goto 4
if '%choice%'=='5' goto 5
if '%choice%'=='6' goto 6
if '%choice%'=='7' goto 7
if '%choice%'=='8' goto 8
if '%choice%'=='9' goto 9


if '%choice%'=='nlb' goto nlb
if '%choice%'=='1010' goto 1010
if '%choice%'=='1011' goto 1011
if '%choice%'=='1012' goto 1012
if '%choice%'=='1013' goto 1013
if '%choice%'=='1014' goto 1014
if '%choice%'=='1019' goto 1019

if '%choice%'=='ns' goto ns
if '%choice%'=='1020' goto 1020
if '%choice%'=='1021' goto 1021
if '%choice%'=='1022' goto 1022
if '%choice%'=='1023' goto 1023
if '%choice%'=='1024' goto 1024
if '%choice%'=='1029' goto 1029


if '%choice%'=='mysql-prod-master' goto mysql-prod-master
if '%choice%'=='1030' goto 1030
if '%choice%'=='1031' goto 1031
if '%choice%'=='1032' goto 1032
if '%choice%'=='1033' goto 1033
if '%choice%'=='1034' goto 1034
if '%choice%'=='1039' goto 1039


if '%choice%'=='mysql-prod-slave' goto mysql-prod-slave
if '%choice%'=='1040' goto 1040
if '%choice%'=='1041' goto 1041
if '%choice%'=='1042' goto 1042
if '%choice%'=='1043' goto 1043
if '%choice%'=='1044' goto 1044
if '%choice%'=='1049' goto 1049


if '%choice%'=='prod-primary' goto prod-primary
if '%choice%'=='1050' goto 1050
if '%choice%'=='1051' goto 1051
if '%choice%'=='1052' goto 1052
if '%choice%'=='1053' goto 1053
if '%choice%'=='1054' goto 1054
if '%choice%'=='1059' goto 1059


if '%choice%'=='prod-secondary' goto prod-secondary
if '%choice%'=='1060' goto 1060
if '%choice%'=='1061' goto 1061
if '%choice%'=='1062' goto 1062
if '%choice%'=='1063' goto 1063
if '%choice%'=='1064' goto 1064
if '%choice%'=='1069' goto 1069

if '%choice%'=='prod-backup' goto prod-backup
if '%choice%'=='1070' goto 1070
if '%choice%'=='1071' goto 1071
if '%choice%'=='1072' goto 1072
if '%choice%'=='1073' goto 1073
if '%choice%'=='1074' goto 1074
if '%choice%'=='1079' goto 1079

if '%choice%'=='build' goto build
if '%choice%'=='1080' goto 1080
if '%choice%'=='1081' goto 1081
if '%choice%'=='1082' goto 1082
if '%choice%'=='1083' goto 1083
if '%choice%'=='1084' goto 1084
if '%choice%'=='1089' goto 1089

if '%choice%'=='dev' goto dev
if '%choice%'=='1090' goto 1090
if '%choice%'=='1091' goto 1091
if '%choice%'=='1092' goto 1092
if '%choice%'=='1093' goto 1093
if '%choice%'=='1094' goto 1094
if '%choice%'=='1099' goto 1099

if not '%choice%'=='' (
	cls
  ECHO.
  call :colored "%choice% - не является допустимым вариантом, попробуйте снова" red
  ECHO.
	)

:status
	cls
	ECHO.
	call :colored "ВЕРСИЯ VAGRANT:" yellow
	ECHO.
	vagrant -v
	ECHO.
	ECHO.
	call :colored "УСТАНОВЛЕННЫЕ ПЛАГИНЫ:" yellow
	ECHO.
	vagrant plugin list
	ECHO.
	ECHO.
	call :colored "ПРОВЕРЯЕМ VAGRANTFILE НА ОШИБКИ:" yellow
	ECHO.
	vagrant validate 
	ECHO.
	ECHO.
	call :colored "ГЛОБАЛЬНЫЙ СТАТУС:" yellow
	ECHO.
	vagrant global-status --prune
	ECHO.
	ECHO.
	call :colored "ТЕКУЩЕЕ СОСТОЯНИЕ ВИРТУАЛЬНЫХ МАШИН:" yellow
	ECHO.
	vagrant status
	ECHO.
	ECHO.
	call :colored "Нажмите любую клавишу для продолжения .." yellow
	pause >nul
	cls
	goto start


:1
  cls
  cd VagrantBoxes
  call :colored "Список установленных контейнеров, включая информацию о версиях:" yellow
  ECHO.
  vagrant box list
  ECHO.
  call :colored "Нажмите любую клавишу для продолжения .." yellow
  pause >nul
  cls

:2
	cls
  goto start

:3
	cls
	ECHO.
	call :colored "Проверяем Vagrantfile на ошибки:" yellow
	ECHO.
	vagrant validate 
	ECHO.
	ECHO.
	call :colored "Текущее состояние виртуальных машин:" yellow
	ECHO.
	vagrant status
	ECHO.
	ECHO.
	call :colored "Нажмите любую клавишу, чтобы начать установку .." yellow
	pause >nul
	cls
	ECHO.
	vagrant up
	ECHO.
	ECHO.
	call :colored "Нажмите любую клавишу для продолжения .." yellow
	pause >nul
	cls
	goto start

:4
	cls
  goto start

:5
	cls
  goto start

:6
	cls
  ECHO.
  call :colored "Сохраняем состояние" yellow
  call :colored "Отправляем все виртуальные машины в сон" yellow
  ECHO.
  vagrant suspend
  ECHO.
	call :colored "Нажмите любую клавишу для продолжения .." yellow
	pause >nul
	cls
	goto status
	
:7
	cls
  ECHO.
  call :colored "Пробуждаем все виртуальные машины из сна" yellow
	ECHO.
  vagrant resume
  ECHO.
	call :colored "Нажмите любую клавишу для продолжения .." yellow
	pause >nul
	cls
	goto status
	
:8
	cls
  ECHO.
	call :colored "Останавливаем все виртуальные машины" yellow
	ECHO.
	vagrant halt
	ECHO.
	call :colored "Уничтожаем все виртуальные машины полностью" yellow
	ECHO.
	vagrant destroy -f
	ECHO.
	call :colored "Удаляем каталог .vagrant" yellow
	ECHO.
	rmdir .vagrant /s /q
	ECHO.
	call :colored "Нажмите любую клавишу для продолжения .." yellow
	pause >nul
	cls
	goto status
	
:9
	cls
	ECHO.
  call :colored "Останавливаем все виртуальные машины" yellow
  ECHO.
  vagrant halt
  ECHO.
  call :colored "Уничтожаем все виртуальные машины полностью" yellow
  ECHO.
  vagrant destroy -f
  ECHO.
  call :colored "СЕРВЕР Удаляем каталог .vagrant" yellow
  ECHO.
  rmdir .vagrant /s /q
  ECHO.
  call :colored "Нажмите любую клавишу для продолжения .." yellow
  call :colored "Сервер будет перезагружен через 60 секунд .." yellow
  pause >nul
  cls
  shutdown -s -t 60
  exit
	
:nlb
	cls
	ECHO.
	call :colored "Сервер Nginx Load Balancer" red
	ECHO.
	vagrant status nlb
	ECHO.
	vagrant port nlb
	ECHO.
	ECHO.
	call :colored "МЕНЮ СЕРВЕРА:" yellow
	ECHO.
	ECHO      1010  - запустить
	ECHO      1011  - остановить
	ECHO      1012  - отправить в сон
	ECHO      1013  -  .. из сна
	ECHO      1014  - удалить полностью
	ECHO      1019  - панель управления
  ECHO.
  goto start
	
:1010
	cls
	ECHO.
	call :colored "Проверяем Vagrantfile на ошибки:" yellow
	ECHO.
	vagrant validate 
	ECHO.
	call :colored "Нажмите любую клавишу для продолжения .." yellow
	pause >nul
	cls
	ECHO.
	vagrant up nlb
	ECHO.
	ECHO.
	call :colored "Нажмите любую клавишу для продолжения .." yellow
	pause >nul
	cls
	goto nlb=
  
:1014
	cls
	ECHO.
	vagrant halt nlb
	ECHO.
	vagrant destroy -f nlb
	ECHO.
	cd .. 
	rmdir .vagrant\machines\nlb /s /q
	cls
	goto nlb

:1019
  cls
  start chrome "http://localhost"
  cls
  goto nlb
	
:ns
	cls
	ECHO.
	call :colored "Сервер мониторинга IT-инфраструктуры, аудита и авторизации" red
	ECHO.
	vagrant status ns
	ECHO.
	vagrant port ns
	ECHO.
	ECHO.
	call :colored "МЕНЮ СЕРВЕРА:" yellow
	ECHO.
	ECHO      1020  - запустить
	ECHO      1021  - остановить
	ECHO      1022  - отправить в сон
	ECHO      1023  -  .. из сна
	ECHO      1024  - удалить полностью
	ECHO      1029  - панель управления
  ECHO.
  goto start
	
:1020
	cls
	ECHO.
	call :colored "Проверяем Vagrantfile на ошибки:" yellow
	ECHO.
	vagrant validate 
	ECHO.
	call :colored "Нажмите любую клавишу для продолжения .." yellow
	pause >nul
	cls
	ECHO.
	vagrant up ns
	ECHO.
	ECHO.
	call :colored "Нажмите любую клавишу для продолжения .." yellow
	pause >nul
	cls
	goto ns
  
:1024
	cls
	ECHO.
	vagrant halt ns
	ECHO.
	vagrant destroy -f ns
	ECHO.
	cd .. 
	rmdir .vagrant\machines\ns /s /q
	cls
	goto ns

:1029
  cls
  start chrome "http://localhost:52102"
  cls
  goto ns
	
:mysql-master
	cls
	ECHO.
	call :colored "MySQL master-сервер баз данных" red
	ECHO.
	vagrant status mysql-master
	ECHO.
	vagrant port mysql-master
	ECHO.
	ECHO.
  call :colored "МЕНЮ СЕРВЕРА:" yellow
	ECHO.
	ECHO      1030  - запустить
	ECHO      1031  - остановить
	ECHO      1032  - отправить в сон
	ECHO      1033  -  .. из сна
	ECHO      1034  - удалить полностью
	ECHO      1039  - панель управления
  ECHO.
  goto start
	
:1030
  cls
  ECHO.
  call :colored "Проверяем Vagrantfile на ошибки:" yellow
  ECHO.
  vagrant validate 
  ECHO.
  call :colored "Нажмите любую клавишу для продолжения .." yellow
  pause >nul
  cls
  ECHO.
  vagrant up mysql-master
  ECHO.
  ECHO.
  call :colored "Нажмите любую клавишу для продолжения .." yellow
  pause >nul
  cls
  goto mysql-master

:1031
	cls
	ECHO.
	vagrant halt mysql-master
	ECHO.
	call :colored "Нажмите любую клавишу для продолжения .." yellow
	pause >nul
	cls
  goto mysql-master
	
:1032
	cls
	ECHO.
	vagrant suspend mysql-master
	ECHO.
	call :colored "Нажмите любую клавишу для продолжения .." yellow
	pause >nul
	cls
  goto mysql-master
	
:1033
	cls
	ECHO.
	vagrant resume mysql-master
	ECHO.
	call :colored "Нажмите любую клавишу для продолжения .." yellow
	pause >nul
	cls
  goto mysql-master
	
:1034
	cls
	ECHO.
	vagrant halt mysql-master
	ECHO.
  vagrant destroy -f mysql-master
  ECHO.
  cd .. 
  rmdir .vagrant\machines\mysql-master /s /q
  cls
  goto mysql-master

:1039
  cls
  start chrome "http://localhost:52104" "http://localhost:5014" "http://localhost:50104/phpmyadmin/"
  cls
  goto mysql-master

:mysql-slave
	cls
	ECHO.
	call :colored "MySQL slave-сервер баз данных" red
	ECHO.
	vagrant status mysql-slave
	ECHO.
	vagrant port mysql-slave
	ECHO.
	ECHO.
  call :colored "МЕНЮ СЕРВЕРА:" yellow
	ECHO.
	ECHO      1040  - запустить
	ECHO      1041  - остановить
	ECHO      1042  - отправить в сон
	ECHO      1043  -  .. из сна
	ECHO      1044  - удалить полностью
	ECHO      1049  - панель управления
  ECHO.
  goto start
	
:1040
  cls
  ECHO.
  call :colored "Проверяем Vagrantfile на ошибки:" yellow
  ECHO.
  vagrant validate 
  ECHO.
  call :colored "Нажмите любую клавишу для продолжения .." yellow
  pause >nul
  cls
  ECHO.
  vagrant up mysql-slave
  ECHO.
  ECHO.
  call :colored "Нажмите любую клавишу для продолжения .." yellow
  pause >nul
  cls
  goto mysql-slave

:1041
	cls
	ECHO.
	vagrant halt mysql-slave
	ECHO.
	call :colored "Нажмите любую клавишу для продолжения .." yellow
	pause >nul
	cls
  goto mysql-slave
	
:1042
	cls
	ECHO.
	vagrant suspend mysql-slave
	ECHO.
	call :colored "Нажмите любую клавишу для продолжения .." yellow
	pause >nul
	cls
  goto mysql-slave
	
:1043
	cls
	ECHO.
	vagrant resume mysql-slave
	ECHO.
	call :colored "Нажмите любую клавишу для продолжения .." yellow
	pause >nul
	cls
  goto mysql-slave
	
:1044
	cls
	ECHO.
	vagrant halt mysql-slave
	ECHO.
  vagrant destroy -f mysql-slave
  ECHO.
  cd .. 
  rmdir .vagrant\machines\mysql-slave /s /q
  cls
  goto mysql-slave

:1049
  cls
  start chrome "http://localhost:52104" "http://localhost:5014" "http://localhost:50104/phpmyadmin/"
  cls
  goto mysql-slave

	
:prod-primary
	cls	
	ECHO.
	call :colored "Production-окружение Веб сервер Nginx+Apache (master)" red
	ECHO.
	vagrant status production-primary
	ECHO.
	vagrant port production-primary
	ECHO.
	ECHO.
	call :colored "МЕНЮ СЕРВЕРА:" yellow
	ECHO.
	ECHO      1050  - запустить
	ECHO      1051  - остановить
	ECHO      1052  - отправить в сон
	ECHO      1053  -  .. из сна
	ECHO      1054  - удалить полностью
	ECHO      1059  - панель управления
  ECHO.
  goto start

:1050
  cls
  ECHO.
  call :colored "Проверяем Vagrantfile на ошибки:" yellow
  ECHO.
  vagrant validate 
  ECHO.
  call :colored "Нажмите любую клавишу для продолжения .." yellow
  pause >nul
  cls
  ECHO.
  vagrant up production-primary
  ECHO.
  ECHO.
  call :colored "Нажмите любую клавишу для продолжения .." yellow
  pause >nul
  cls
  goto prod-primary
	
:1051
	cls
	ECHO.
	vagrant halt production-primary
	ECHO.
	call :colored "Нажмите любую клавишу для продолжения .." yellow
	pause >nul
	cls
  goto prod-primary
	
:1052
	cls
	ECHO.
	vagrant suspend production-primary
	ECHO.
	call :colored "Нажмите любую клавишу для продолжения .." yellow
	pause >nul
	cls
  goto prod-primary
	
:1053
	cls
	ECHO.
	vagrant resume production-primary
	ECHO.
	call :colored "Нажмите любую клавишу для продолжения .." yellow
	pause >nul
	cls
	goto prod-primary
	
:1054
	cls
	ECHO.
	vagrant halt production-primary
	ECHO.
	vagrant destroy -f production-primary
	ECHO.
	rem  cd .. 
	rmdir .vagrant\machines\production-primary /s /q
	cls
	goto prod-primary

:1059
  cls
  start chrome "http://localhost:52105" 
  cls
  goto prod-primary
  
:prod-secondary
	cls	
	ECHO.
	call :colored "Production-окружение Веб сервер Nginx+Apache (slave)" red
	ECHO.
	vagrant status production-secondary
	ECHO.
	vagrant port production-secondary
	ECHO.
	ECHO.
	call :colored "МЕНЮ СЕРВЕРА:" yellow
	ECHO.
	ECHO      1060  - запустить
	ECHO      1061  - остановить
	ECHO      1062  - отправить в сон
	ECHO      1063  -  .. из сна
	ECHO      1064  - удалить полностью
	ECHO      1069  - панель управления
  ECHO.
  goto start

:1060
  cls
  ECHO.
  call :colored "Проверяем Vagrantfile на ошибки:" yellow
  ECHO.
  vagrant validate 
  ECHO.
  call :colored "Нажмите любую клавишу для продолжения .." yellow
  pause >nul
  cls
  ECHO.
  vagrant up production-secondary
  ECHO.
  ECHO.
  call :colored "Нажмите любую клавишу для продолжения .." yellow
  pause >nul
  cls
  goto prod-secondary
	
:1061
	cls
	ECHO.
	vagrant halt production-secondary
	ECHO.
	call :colored "Нажмите любую клавишу для продолжения .." yellow
	pause >nul
	cls
  goto prod-secondary
	
:1062
	cls
	ECHO.
	vagrant suspend production-secondary
	ECHO.
	call :colored "Нажмите любую клавишу для продолжения .." yellow
	pause >nul
	cls
  goto prod-secondary
	
:1063
	cls
	ECHO.
	vagrant resume production-secondary
	ECHO.
	call :colored "Нажмите любую клавишу для продолжения .." yellow
	pause >nul
	cls
	goto prod-secondary
	
:1064
	cls
	ECHO.
	vagrant halt production-secondary
	ECHO.
	vagrant destroy -f production-secondary
	ECHO.
	rem  cd .. 
	rmdir .vagrant\machines\production-secondary /s /q
	cls
	goto prod-secondary

:1069
  cls
  start chrome "http://localhost:52106"
  cls
  goto prod-secondary
  
:prod-backup
	cls	
	ECHO.
	call :colored "Production-окружение Веб сервер Nginx+Apache (backup)" red
	ECHO.
	vagrant status production-secondary
	ECHO.
	vagrant port production-secondary
	ECHO.
	ECHO.
	call :colored "МЕНЮ СЕРВЕРА:" yellow
	ECHO.
	ECHO      1070  - запустить
	ECHO      1071  - остановить
	ECHO      1072  - отправить в сон
	ECHO      1073  -  .. из сна
	ECHO      1074  - удалить полностью
	ECHO      1079  - панель управления
  ECHO.
  goto start

:1070
  cls
  ECHO.
  call :colored "Проверяем Vagrantfile на ошибки:" yellow
  ECHO.
  vagrant validate 
  ECHO.
  call :colored "Нажмите любую клавишу для продолжения .." yellow
  pause >nul
  cls
  ECHO.
  vagrant up production-backup
  ECHO.
  ECHO.
  call :colored "Нажмите любую клавишу для продолжения .." yellow
  pause >nul
  cls
  goto prod-backup
	
:1071
	cls
	ECHO.
	vagrant halt production-backup
	ECHO.
	call :colored "Нажмите любую клавишу для продолжения .." yellow
	pause >nul
	cls
  goto prod-backup
	
:1072
	cls
	ECHO.
	vagrant suspend production-backup
	ECHO.
	call :colored "Нажмите любую клавишу для продолжения .." yellow
	pause >nul
	cls
  goto prod-backup
	
:1073
	cls
	ECHO.
	vagrant resume production-backup
	ECHO.
	call :colored "Нажмите любую клавишу для продолжения .." yellow
	pause >nul
	cls
	goto prod-backup
	
:1074
	cls
	ECHO.
	vagrant halt production-backup
	ECHO.
	vagrant destroy -f production-backup
	ECHO.
	rem  cd .. 
	rmdir .vagrant\machines\production-backup /s /q
	cls
	goto prod-backup
  
:build
	cls	
	ECHO.
	call :colored "Сервер непрерывной интеграции (билд-сервер)" red
	ECHO.
	vagrant status production-secondary
	ECHO.
	vagrant port production-secondary
	ECHO.
	ECHO.
	call :colored "МЕНЮ СЕРВЕРА:" yellow
	ECHO.
	ECHO      1080  - запустить
	ECHO      1081  - остановить
	ECHO      1082  - отправить в сон
	ECHO      1083  -  .. из сна
	ECHO      1084  - удалить полностью
	ECHO      1089  - панель управления
	ECHO.
	goto start

:1080
  cls
  ECHO.
  call :colored "Проверяем Vagrantfile на ошибки:" yellow
  ECHO.
  vagrant validate 
  ECHO.
  call :colored "Нажмите любую клавишу для продолжения .." yellow
  pause >nul
  cls
  ECHO.
  vagrant up build
  ECHO.
  ECHO.
  call :colored "Нажмите любую клавишу для продолжения .." yellow
  pause >nul
  cls
  goto build
	
:1081
	cls
	ECHO.
	vagrant halt build
	ECHO.
	call :colored "Нажмите любую клавишу для продолжения .." yellow
	pause >nul
	cls
  goto build
	
:1082
	cls
	ECHO.
	vagrant suspend build
	ECHO.
	call :colored "Нажмите любую клавишу для продолжения .." yellow
	pause >nul
	cls
  goto build
	
:1083
	cls
	ECHO.
	vagrant resume build
	ECHO.
	call :colored "Нажмите любую клавишу для продолжения .." yellow
	pause >nul
	cls
	goto build
	
:1084
	cls
	ECHO.
	vagrant halt build
	ECHO.
	vagrant destroy -f build
	ECHO.
	rem  cd .. 
	rmdir .vagrant\machines\build /s /q
	cls
	goto build

:1089
  cls
  start chrome "http://localhost:52108"
  cls
  goto build
  
:dev
	cls	
	ECHO.
	call :colored "Сервер непрерывной интеграции (билд-сервер)" red
	ECHO.
	vagrant status production-secondary
	ECHO.
	vagrant port production-secondary
	ECHO.
	ECHO.
	call :colored "МЕНЮ СЕРВЕРА:" yellow
	ECHO.
	ECHO      1090  - запустить
	ECHO      1091  - остановить
	ECHO      1092  - отправить в сон
	ECHO      1093  -  .. из сна
	ECHO      1094  - удалить полностью
	ECHO      1099  - панель управления
	ECHO.
	goto start

:1090
  cls
  ECHO.
  call :colored "Проверяем Vagrantfile на ошибки:" yellow
  ECHO.
  vagrant validate 
  ECHO.
  call :colored "Нажмите любую клавишу для продолжения .." yellow
  pause >nul
  cls
  ECHO.
  vagrant up dev
  ECHO.
  ECHO.
  call :colored "Нажмите любую клавишу для продолжения .." yellow
  pause >nul
  cls
  goto dev
	
:1091
	cls
	ECHO.
	vagrant halt dev
	ECHO.
	call :colored "Нажмите любую клавишу для продолжения .." yellow
	pause >nul
	cls
  goto dev
	
:1092
	cls
	ECHO.
	vagrant suspend dev
	ECHO.
	call :colored "Нажмите любую клавишу для продолжения .." yellow
	pause >nul
	cls
  goto dev
	
:1093
	cls
	ECHO.
	vagrant resume dev
	ECHO.
	call :colored "Нажмите любую клавишу для продолжения .." yellow
	pause >nul
	cls
	goto dev
	
:1094
	cls
	ECHO.
	vagrant halt dev
	ECHO.
	vagrant destroy -f dev
	ECHO.
	rem  cd .. 
	rmdir .vagrant\machines\dev /s /q
	cls
	goto dev

:1099
  cls
  start chrome "http://localhost:52109"
  cls
  goto dev

	
	
:colored
	%Windir%\System32\WindowsPowerShell\v1.0\Powershell.exe write-host -foregroundcolor %2 %1