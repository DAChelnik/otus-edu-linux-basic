#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

# ПРИМЕЧАНИЯ
#   В конце каждой команды вы можете увидеть > / dev / null . Это просто подавляет вывод из процессов установки.
#   Если вы хотите увидеть результат при подготовке, просто удалите его.
#   Когда вы пытаетесь установить пакет с помощью команды apt-get install , он всегда запрашивает подтверждение, 
#   флаг -y указывает «да», поэтому он не будет запрашивать подтверждение каждой установки.



#           https://27sysday.ru/programmirovanie/nastroyka-web-servera-na-ubuntu-20-04

echo -e "\n"
echo -e "\e[33m Устанавливаем дополнительные пакеты: \e[0m"
apt-get -y install dirmngr > /dev/null


echo -e "\e[33m FASTPANEL — простая и функциональная панель управления сервером \e[0m"
echo -e "\e[33m - устанавливаем FASTPANEL \e[0m"
sudo wget -q -O - http://repo.fastpanel.direct/install_fastpanel.sh | sudo bash -


echo -e ""
echo -e "\e[33m Брандмауэр UFW \e[0m"
echo -e "\e[33m - открываем порт 8888 для работы приложения \e[0m"
sudo ufw allow 8888 > /dev/null
sudo ufw allow 7777 > /dev/null
echo -e "\e[33m - перезагружаем брандмауэр, чтобы изменения вступили в силу \e[0m"
sudo ufw reload
echo -e "\n"