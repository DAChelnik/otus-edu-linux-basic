#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

# ПРИМЕЧАНИЯ
#   В конце каждой команды вы можете увидеть > / dev / null . Это просто подавляет вывод из процессов установки.
#   Если вы хотите увидеть результат при подготовке, просто удалите его.
#   Когда вы пытаетесь установить пакет с помощью команды apt-get install , он всегда запрашивает подтверждение, 
#   флаг -y указывает «да», поэтому он не будет запрашивать подтверждение каждой установки.
echo -e "\n"
echo -e "\e[33m Cockpit — интерактивный интерфейс администратора серверов \e[0m"
echo -e "\e[33m - устанавливаем Cockpit \e[0m"
apt-get install -y cockpit > /dev/null
echo -e "\e[33m - добавляем службу в автозагрузку \e[0m"
sudo systemctl enable --now cockpit.socket
echo -e "\e[33m - запускаем службу \e[0m"
sudo systemctl start cockpit > /dev/null
echo -e ""
echo -e "\e[33m Устанавливаем модули: \e[0m"
echo -e "\e[33m - cockpit-dashboard \e[0m"
echo -e "\e[33m   модуль управления множеством серверов из одной сессии  \e[0m"
apt-get install -y cockpit-dashboard > /dev/null
echo -e "\e[33m - cockpit-storaged \e[0m"
echo -e "\e[33m   модуль управления системными хранилищами данных, включая \e[0m"
echo -e "\e[33m   создание и форматирование разделов и управление LVM-томами  \e[0m"
apt-get install -y cockpit-storaged > /dev/null
echo -e "\e[33m - cockpit-packagekit \e[0m"
echo -e "\e[33m   согласованный API для прикладного программного обеспечения \e[0m"
apt-get install -y cockpit-packagekit > /dev/null
echo -e ""
echo -e "\e[33m Перезапускаем службу Cockpit \e[0m"
sudo systemctl restart cockpit.socket
echo -e ""
echo -e "\e[33m Брандмауэр UFW \e[0m"
echo -e "\e[33m - открываем порт 9090 для работы приложения \e[0m"
sudo ufw allow 9090 > /dev/null
echo -e "\e[33m - перезагружаем брандмауэр, чтобы изменения вступили в силу \e[0m"
sudo ufw reload
echo -e "\n"

# Fix the problem: cannot refresh cache whilst offline
#   sudo systemctl stop network-manager.service > /dev/null
#   sudo systemctl disable network-manager.service > /dev/null