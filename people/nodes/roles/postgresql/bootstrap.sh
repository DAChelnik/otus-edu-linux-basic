#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

# ПРИМЕЧАНИЯ:
#   В конце каждой команды вы можете увидеть > / dev / null . Это просто подавляет вывод из процессов установки.
#   Если вы хотите увидеть результат при подготовке, просто удалите его.
#   Когда вы пытаетесь установить пакет с помощью команды apt-get install , он всегда запрашивает подтверждение, 
#   флаг -y указывает «да», поэтому он не будет запрашивать подтверждение каждой установки.
echo -e "\n"
echo -e "\e[33m Инициализация PostgreSQL-кластера \e[0m \n"
echo -e "\e[33m Устанавливаем необходимые пакеты: \e[0m"
apt-get -y install postgresql-contrib > /dev/null
apt-get -y install libdbi-perl > /dev/null
apt-get -y install libdbd-pg-perl > /dev/null
apt-get -y install lsb-core > /dev/null

echo -e "\e[33m Устанавливаем Apache сервер \e[0m"
apt-get -y install apache2 > /dev/null

echo -e "\e[33m Брандмауэр UFW \e[0m"
echo -e "\e[33m - открываем необходимые порты для работы Apache \e[0m"
sudo ufw allow 'Apache Full' > /dev/null
echo -e "\e[33m - перезагружаем брандмауэр, чтобы изменения вступили в силу \e[0m"
sudo ufw reload
echo -e "\n"


# УСТАНОВКА PostgreSQL:
#   При установке пакета инсталлятор создаст новый PostgreSQL-кластер. Данный кластер представляет из себя коллекцию 
#   баз данных, которая управляется одним сервером. Также, установщик создаст рабочие директории для PostgreSQL. 
#   Данные, необходимые для работы PostgreSQL, будут находится в каталоге /var/lib/postgresql/12/main,
#   а файлы конфигурации – в каталоге /etc/postgresql/12/main.

#   https://ruvds.com/ru/helpcenter/postgresql-pgadmin-ubuntu/

echo -e "\e[33m Устанавливаем PostgreSQL-кластер \e[0m"
apt-get -y install postgresql > /dev/null


sudo wget -q -O- https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo apt-key add -
sudo sh -c 'echo "deb https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list' > /dev/null
apt-get update > /dev/null
apt-get -y install pgadmin4 > /dev/null







