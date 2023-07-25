#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

# Примечания:
#   В конце каждой команды вы можете увидеть > / dev / null . Это просто подавляет вывод из процессов установки.
#   Если вы хотите увидеть результат при подготовке, просто удалите его.
#   Когда вы пытаетесь установить пакет с помощью команды apt-get install , он всегда запрашивает подтверждение, 
#   флаг -y указывает «да», поэтому он не будет запрашивать подтверждение каждой установки.
echo -e "\n"
echo -e "\e[33m Инициализация сервера Nginx Load Balancer \e[0m"

#   https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-ubuntu-22-04

apt-get -y install nginx > /dev/null

sudo rm -rf /etc/nginx/sites-available/default
cp  /vagrant/nodes/config/nlb/etc/nginx/sites-available/default /etc/nginx/sites-available/


# Перезапускаем Nginx (останавливаем, а затем запускаем службу)
sudo service nginx restart


echo -e "\e[33m Брандмауэр UFW \e[0m"
echo -e "\e[33m - открываем необходимые порты для работы Nginx \e[0m"
sudo ufw allow 'Nginx HTTP' > /dev/null
echo -e "\n"

