#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

# Примечания:
#   В конце каждой команды вы можете увидеть > / dev / null . Это просто подавляет вывод из процессов установки.
#   Если вы хотите увидеть результат при подготовке, просто удалите его.
#   Когда вы пытаетесь установить пакет с помощью команды apt-get install , он всегда запрашивает подтверждение, 
#   флаг -y указывает «да», поэтому он не будет запрашивать подтверждение каждой установки.
echo -e "\n"
echo -e "\e[33m Base Docker development \e[0m"

#   https://timeweb.cloud/tutorials/docker/kak-ustanovit-docker-na-ubuntu-22-04


echo -e "\e[33m Устанавливаем дополнительные пакеты и утилиты: \e[0m"


sudo apt install apt-transport-https 

echo -e "\e[33m - gnupg \e[0m"
apt-get -y install gnupg > /dev/null

echo -e "\e[33m - ca-certificates \e[0m"
apt-get  -y install ca-certificates > /dev/null

echo -e "\e[33m - lsb-release \e[0m"
apt-get  -y install lsb-release > /dev/null

echo -e "\e[33m - software-properties-common \e[0m"
apt-get -y install software-properties-common > /dev/null

echo -e "\e[33m - доступ к APT-репозиториям по протоколу HTTPS \e[0m"
apt-get -y install apt-transport-https > /dev/null
echo -e ""

sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo -e ""
echo -e "\e[33m Синхронизируем списки пакетов и репозиториев \e[0m"
echo -e "\e[33m   и обеспечиваем их актуальность \e[0m"
apt-get -qqy update > /dev/null
echo -e ""


apt-cache policy docker-ce > /dev/null
apt-get -y install docker-ce > /dev/null

mkdir -p ~/.docker/cli-plugins/
curl -SL https://github.com/docker/compose/releases/download/v2.3.3/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose
chmod +x ~/.docker/cli-plugins/docker-compose



sudo mkdir /var/compose-otus
cd /var/compose-otus

sudo git clone https://github.com/DAChelnik/otus-edu-linux-basic

cd /var/compose-otus/otus-edu-linux-basic
sudo git checkout project-work > /dev/null

sudo docker network create meropa > /dev/null


cd /var/compose-otus/otus-edu-linux-basic/docker/www
sudo docker compose up -d

cd /var/compose-otus/otus-edu-linux-basic/docker/www-unicom
sudo docker compose up -d

cd /var/compose-otus/otus-edu-linux-basic/docker/nginx
sudo docker compose up -d