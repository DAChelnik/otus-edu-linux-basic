#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

# Примечания:
#   В конце каждой команды вы можете увидеть > / dev / null . Это просто подавляет вывод из процессов установки.
#   Если вы хотите увидеть результат при подготовке, просто удалите его.
#   Когда вы пытаетесь установить пакет с помощью команды apt-get install , он всегда запрашивает подтверждение, 
#   флаг -y указывает «да», поэтому он не будет запрашивать подтверждение каждой установки.
echo -e "\n"
echo -e "\e[33m Инициализация сервера мониторинга IT-инфраструктуры \e[0m"
echo -e "\e[33m аудита и авторизации \e[0m \n"

#   https://www.digitalocean.com/community/tutorials/how-to-configure-bind-as-a-private-network-dns-server-on-ubuntu-18-04-ru
#   https://infoit.com.ua/linux/kak-ustanovit-dns-server-v-ubuntu-20-04-lts/


apt-get -y install bind9 > /dev/null
apt-get -y install bind9utils > /dev/null
apt-get -y install bind9-doc > /dev/null

echo 'OPTIONS="-u bind -4"' >> /etc/default/bind9

sudo systemctl restart bind9


echo -e "\e[33m Брандмауэр UFW \e[0m"
echo -e "\e[33m - разрешаем порт привязки \e[0m"
sudo ufw allow Bind9 > /dev/null
echo -e "\n"

