#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

# ПРИМЕЧАНИЯ:
#   В конце каждой команды вы можете увидеть > / dev / null . Это просто подавляет вывод из процессов установки.
#   Если вы хотите увидеть результат при подготовке, просто удалите его.
#   Когда вы пытаетесь установить пакет с помощью команды apt-get install , он всегда запрашивает подтверждение, 
#   флаг -y указывает «да», поэтому он не будет запрашивать подтверждение каждой установки.


#
echo -e "\n"
echo -e "\e[33m Применяем общую конфигурацию для всех виртуальных машин \e[0m"
echo -e ""
echo -e "\e[33m Синхронизируем списки пакетов и репозиториев \e[0m"
echo -e "\e[33m   и обеспечиваем их актуальность \e[0m"
apt-get -qqy update
echo -e ""

#
echo -e "\e[33m Устанавливаем базовые пакеты и утилиты: \e[0m"
echo -e "\e[33m - Midnight Commander (mc) \e[0m"
apt-get -y install mc > /dev/null


# ВРЕМЯ:
#   Для корректного отображения времени, необходимо синхронизировать его с внешним источником.
#   Также необходимо задать корректный часовой пояс. 
#   Задаем зону по московскому времени. Список все доступных зон можно посмотреть командой timedatectl list-timezones.
echo -e "\e[33m Синхронизация времени: \e[0m"
echo -e "\e[33m - задаём часовой пояс по московскому времени \e[0m"
sudo timedatectl set-timezone Europe/Moscow > /dev/null
echo -e "\e[33m - устанавливаем chrony, альтернативный клиент и сервер NTP \e[0m"
apt-get -y install chrony > /dev/null
echo -e "\e[33m - разрешаем запуск при загрузке системы \e[0m"
sudo systemctl enable chrony > /dev/null
echo -e "\n"

# НАСТРОЙКА UFW:
#   Во всех дистрибутивах Linux для обеспечения сетевой безопасности и изоляции внутренних процессов от внешней среды используется
#   брандмауэр iptables. Но его настройка может показаться очень сложной для новых пользователей, поэтому многие дистрибутивы создают 
#   собственные оболочки, которые упрощают процесс настройки.
#   В Ubuntu используется оболочка под названием UFW или  Uncomplicated FireWall. 
echo -e "\e[33m Включаем брандмауэр UFW \e[0m"
echo -e "\e[33m - открываем порт ufw для SSH \e[0m"
sudo ufw allow OpenSSH > /dev/null
sudo ufw --force enable > /dev/null
echo -e "\e[33m - перезагружаем брандмауэр, чтобы изменения вступили в силу \e[0m"
sudo ufw reload
echo -e "\n"