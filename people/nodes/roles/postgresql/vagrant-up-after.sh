#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

# Примечания:
#   В конце каждой команды вы можете увидеть > / dev / null . Это просто подавляет вывод из процессов установки.
#   Если вы хотите увидеть результат при подготовке, просто удалите его.
#   Когда вы пытаетесь установить пакет с помощью команды apt-get install , он всегда запрашивает подтверждение, 
#   флаг -y указывает «да», поэтому он не будет запрашивать подтверждение каждой установки.
echo -e "\n"

echo -e "\e[33m Брандмауэр UFW \e[0m"
echo -e "\e[33m - состояние и действующие на данный момент правила: \e[0m"
sudo ufw status verbose
echo -e "\n"

#
echo -e "\e[33m PostgreSQL-кластер установлен \e[0m"
echo -e ""
echo -e "\e[33m - убедимся, что служба PostgreSQL активна \e[0m"
sudo systemctl is-active postgresql
echo -e ""
echo -e "\e[33m - убедимся, что служба включена \e[0m"
sudo systemctl is-enabled postgresql
echo -e ""
echo -e "\e[33m - статус службы PostgreSQL \e[0m"
sudo systemctl status postgresql
echo -e ""
echo -e "\e[33m - убедимся, что PostgreSQL-сервер готов принимать подключения от клиентов: \e[0m"
sudo pg_isready
echo -e "\n"