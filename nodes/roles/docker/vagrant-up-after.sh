#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

# Примечания:
#   В конце каждой команды вы можете увидеть > / dev / null . Это просто подавляет вывод из процессов установки.
#   Если вы хотите увидеть результат при подготовке, просто удалите его.
#   Когда вы пытаетесь установить пакет с помощью команды apt-get install , он всегда запрашивает подтверждение, 
#   флаг -y указывает «да», поэтому он не будет запрашивать подтверждение каждой установки.

echo -e ""
docker compose version

echo -e ""
sudo systemctl status docker

echo -e ""
cd /var/compose-otus/otus-edu-linux-basic/docker/nginx
sudo docker compose ps --all

echo -e ""
cd /var/compose-otus/otus-edu-linux-basic/docker/www
sudo docker compose ps --all

echo -e ""
cd /var/compose-otus/otus-edu-linux-basic/docker/www-unicom
sudo docker compose ps --all