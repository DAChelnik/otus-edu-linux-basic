#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

# ПРИМЕЧАНИЯ
#   В конце каждой команды вы можете увидеть > / dev / null . Это просто подавляет вывод из процессов установки.
#   Если вы хотите увидеть результат при подготовке, просто удалите его.
#   Когда вы пытаетесь установить пакет с помощью команды apt-get install , он всегда запрашивает подтверждение, 
#   флаг -y указывает «да», поэтому он не будет запрашивать подтверждение каждой установки.

# https://infoit.com.ua/linux/kak-ustanovit-virtualmin-na-ubuntu-20-04-lts/
# Virtualmin — это мощная и гибкая панель управления веб-хостингом для систем Linux и BSD. 
#   С Virtualmin вы сможете управлять Apache, Nginx, PHP, DNS, MySQL, PostgreSQL, почтовыми ящиками, 
#   FTP, SSH, SSL, репозиториями Subversion / Git и многими другими.

echo -e "\n\e[33m Virtualmin — панель для управления веб-хостингом \e[0m\n"

echo -e "\e[33m - загружаем скрипт Virtualmin \e[0m"
curl -O http://software.virtualmin.com/gpl/scripts/install.sh

echo -e "\e[33m - делаем скрипт исполняемым \e[0m"
sudo chmod +x install.sh

echo -e "\e[33m - устанавливаем Virtualmin \e[0m"
sudo ./install.sh -y