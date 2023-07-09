#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

# ПРИМЕЧАНИЯ
#   В конце каждой команды вы можете увидеть > / dev / null . Это просто подавляет вывод из процессов установки.
#   Если вы хотите увидеть результат при подготовке, просто удалите его.
#   Когда вы пытаетесь установить пакет с помощью команды apt-get install , он всегда запрашивает подтверждение, 
#   флаг -y указывает «да», поэтому он не будет запрашивать подтверждение каждой установки.

#   https://infoit.com.ua/linux/kak-ustanovit-webmin-v-ubuntu-20-04-ubuntu-18-08/
#   https://www.digitalocean.com/community/tutorials/how-to-install-webmin-on-ubuntu-20-04-ru
#   https://www.digitalocean.com/community/tutorials/how-to-install-webmin-on-ubuntu-22-04
echo -e "\n"

echo -e "\e[33m Устанавливаем дополнительные пакеты: \e[0m"
echo -e "\e[33m - perl \e[0m"
apt-get -y install perl > /dev/null
echo -e "\e[33m - libnet-ssleay-perl \e[0m"
apt-get -y install libnet-ssleay-perl > /dev/null
echo -e "\e[33m - openssl \e[0m"
apt-get -y install openssl > /dev/null
echo -e "\e[33m - libauthen-pam-perl \e[0m"
apt-get -y install libauthen-pam-perl > /dev/null
echo -e "\e[33m - libpam-runtime \e[0m"
apt-get -y install libpam-runtime > /dev/null
echo -e "\e[33m - libio-pty-perl \e[0m"
apt-get -y install libio-pty-perl > /dev/null
echo -e "\e[33m - apt-show-versions \e[0m"
apt-get -y install apt-show-versions > /dev/null
echo -e "\e[33m - python \e[0m"
apt-get -y install python > /dev/null
echo -e "\n"

# WEBMIN:
#   Вначале необходимо добавить репозиторий Webmin, чтобы мы могли устанавливать и обновлять Webmin с помощью нашего диспетчера пакетов. 
#   Для этого мы добавим репозиторий в файл /etc/apt/sources.list
echo -e "\e[33m Webmin — современная веб-панель управления: \e[0m"
echo -e "\e[33m - добавляем официальный репозиторий Webmin в источники приложений \e[0m"
sudo echo "deb http://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list
sudo echo "deb http://webmin.mirror.somersettechsolutions.co.uk/repository sarge contrib" >> /etc/apt/sources.list
echo -e "\e[33m - добавляем GPG-ключ репозитория \e[0m"
sudo wget -q -O- http://www.webmin.com/jcameron-key.asc | sudo apt-key add -
echo -e "\e[33m - обновляем список пакетов, чтобы добавить в него репозиторий Webmin \e[0m"
echo -e "\e[33m   которому система теперь доверяет \e[0m"
apt-get update > /dev/null
echo -e "\e[33m - устанавливаем Webmin \e[0m"
apt-get -y install webmin > /dev/null
echo -e "\n"

# НАСТРОЙКА UFW:
echo -e "\e[33m Брандмауэр UFW \e[0m"
echo -e "\e[33m - открываем порт 10000 для работы приложения \e[0m"
sudo ufw allow 10000/tcp > /dev/null
echo -e "\e[33m - перезагружаем брандмауэр, чтобы изменения вступили в силу \e[0m"
sudo ufw reload
echo -e "\n"