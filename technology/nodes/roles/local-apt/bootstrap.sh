#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

#  Примечания:
#     В конце каждой команды вы можете увидеть > / dev / null . Это просто подавляет вывод из процессов установки.
#     Если вы хотите увидеть результат при подготовке, просто удалите его.
#     Когда вы пытаетесь установить пакет с помощью команды apt-get install , он всегда запрашивает подтверждение, 
#     флаг -y указывает «да», поэтому он не будет запрашивать подтверждение каждой установки.

echo -e "\n"
echo -e "\e[33m Инициализация локального сервера репозитория APT .. \e[0m \n"

echo -e "\n"
echo -e "\e[33m Устанавливаем базовые пакеты: \e[0m"
echo -e "\e[33m - Apache сервер \e[0m"
apt-get -y install apache2 > /dev/null

echo -e "\e[33m Включаем Apache mod rewrite \e[0m"
sudo a2enmod rewrite

sudo sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf

# Перезапускаем Apache (останавливаем, а затем запускаем службу)
sudo service apache2 restart

echo -e "\e[33m Брандмауэр UFW \e[0m"
echo -e "\e[33m - открываем необходимые порты для работы Apache \e[0m"
sudo ufw allow 'Apache Full' > /dev/null

#   https://www.linuxtechi.com/setup-local-apt-repository-server-ubuntu/
#   https://infoit.com.ua/linux/kak-nastroit-lokalnyj-server-repozitoriya-apt-v-ubuntu-20-04/

# Создаём локальный каталог репозитория пакетов с именем ubuntu в пути /var/www/html
sudo mkdir -p /var/www/html/ubuntu
# Устанавливаем необходимые разрешения для созданного выше каталога.
sudo chown www-data:www-data /var/www/html/ubuntu

# Устанавливаем apt-mirror
#   Следующим шагом является установка пакета apt-mirror, после установки этого пакета мы получим команду или инструмент apt-mirror, который
#   загрузит и синхронизирует удаленные пакеты debian с локальным репозиторием на нашем сервере.
sudo apt update
sudo apt install -y apt-mirror

# Настроим репозитории для зеркалирования или синхронизации
sudo cp /etc/apt/mirror.list /etc/apt/mirror.list-bak
sudo rm -rf /etc/apt/mirror.list

cat > /etc/apt/mirror.list <<EOF
set base_path    /var/www/html/ubuntu
set nthreads     20
set _tilde 0
deb http://archive.ubuntu.com/ubuntu jammy main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu jammy-security main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu jammy-updates main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu jammy-proposed main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu jammy-backports main restricted universe multiverse
clean http://archive.ubuntu.com/ubuntu
EOF

sudo mkdir -p /var/www/html/ubuntu/var
sudo cp /var/spool/apt-mirror/var/postmirror.sh /var/www/html/ubuntu/var

cat > cnf.sh <<EOF
#!/bin/bash
for p in "${1:-jammy}"{,-{security,updates,proposed,backports}}\
/{main,restricted,universe,multiverse};do >&2 echo "${p}"
wget -q -c -r -np -R "index.html*"\
 "http://archive.ubuntu.com/ubuntu/dists/${p}/cnf/Commands-amd64.xz"
wget -q -c -r -np -R "index.html*"\
 "http://archive.ubuntu.com/ubuntu/dists/${p}/cnf/Commands-i386.xz"
done
EOF

sudo chmod +x cnf.sh

sudo (crontab -l 2>/dev/null; echo "00  01  *  *  *  /usr/bin/apt-mirror") | crontab -