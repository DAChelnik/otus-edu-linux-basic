#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

# Примечания:
#   В конце каждой команды вы можете увидеть > / dev / null . Это просто подавляет вывод из процессов установки.
#   Если вы хотите увидеть результат при подготовке, просто удалите его.
#   Когда вы пытаетесь установить пакет с помощью команды apt-get install , он всегда запрашивает подтверждение, 
#   флаг -y указывает «да», поэтому он не будет запрашивать подтверждение каждой установки.
echo -e "\n"
echo -e "\e[33m Инициализация MySQL сервера баз данных .. \e[0m \n"

echo -e "\n"
echo -e "\e[33m Устанавливаем базовые пакеты: \e[0m"
echo -e "\e[33m - Apache сервер \e[0m"
apt-get -y install apache2 > /dev/null

echo -e "\e[33m - PHP версии $PHPVERSION \e[0m"
apt-get -y install php$PHPVERSION libapache2-mod-php$PHPVERSION > /dev/null

echo -e "\e[33m - необходимые PHP расширения \e[0m"
apt-get -y install php$PHPVERSION-mysql > /dev/null
apt-get -y install php$PHPVERSION-memcached > /dev/null
apt-get -y install php$PHPVERSION-pgsql > /dev/null
apt-get -y install php$PHPVERSION-gd > /dev/null
apt-get -y install php$PHPVERSION-imagick > /dev/null
apt-get -y install php$PHPVERSION-intl > /dev/null
apt-get -y install php$PHPVERSION-xml > /dev/null
apt-get -y install php$PHPVERSION-zip > /dev/null
apt-get -y install php$PHPVERSION-mbstring > /dev/null
apt-get -y install php$PHPVERSION-curl > /dev/null

echo -e "\e[33m Устанавливаем MySQL root user password \e[0m"
debconf-set-selections <<< "mysql-server mysql-server/root_password password $DB_ROOT_PASSWD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $DB_ROOT_PASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $DB_ROOT_PASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $DB_ROOT_PASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $DB_ROOT_PASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none"

echo -e "\e[33m Устанавливаем MySQL server \e[0m"
apt-get -y install mysql-server mysql-client > /dev/null

apt-get -y -f install libdbi-perl > /dev/null
apt-get -y -f install libdbd-mysql-perl > /dev/null

# Устраняем необходимость вводить логин и пароль.
# Сохраним пароль в ~/.my.cnf После этого mysql и mysqladmin просить пароль перестанут.
echo -e "\e[33m Создаём файл конфигурации учетной записи \e[0m"
sudo cat > /$DB_ROOT_USER/.my.cnf <<EOF
[client]
user="$DB_ROOT_USER"
password="$DB_ROOT_PASSWD"
EOF

sudo mysql -uroot -e "CREATE USER '$DB_ROOT_USER'@'%' IDENTIFIED BY '$DB_ROOT_PASSWD'"
sudo mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO '$DB_ROOT_USER'@'%' WITH GRANT OPTION"
sudo mysql -uroot -e "FLUSH PRIVILEGES;"
# service mysql restart

echo -e "\e[33m Создаём базу данных сервера разработки приложений $DB_ROOT_NAME \e[0m"
sudo mysql -uroot -e "CREATE DATABASE IF NOT EXISTS $DB_ROOT_NAME"
sudo mysql -uroot -e "GRANT ALL PRIVILEGES ON $DB_ROOT_NAME.* to '$DB_ROOT_USER'@'%'"
sudo mysql -uroot -e "FLUSH PRIVILEGES;"

echo -e "\e[33m Устанавливаем MySQL интерфейс phpMyAdmin \e[0m"
apt-get -y install phpmyadmin > /dev/null

sudo sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
echo -e "\e[33m Включаем Apache mod rewrite \e[0m"
sudo a2enmod rewrite

sudo sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf
sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/$PHPVERSION/apache2/php.ini
sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php/$PHPVERSION/apache2/php.ini


# Перезапускаем Apache (останавливаем, а затем запускаем службу)
sudo service apache2 restart
# Перезапускаем MySQL (останавливаем, а затем запускаем службу)
sudo service mysql restart

echo -e "\e[33m Брандмауэр UFW \e[0m"
echo -e "\e[33m - открываем необходимые порты для работы Apache \e[0m"
sudo ufw allow 'Apache Full' > /dev/null
echo -e "\e[33m - открываем порт 3306 для работы MySQL \e[0m"
sudo ufw allow 3306/tcp > /dev/null

echo -e "\e[33m Настраиваем права доступа к папке /backup \e[0m"
sudo mkdir /backup/mysql-dump
sudo chown -R root:root /backup/mysql-dump/
sudo chmod -R 775 /backup/mysql-dump/
sudo cp -Rf /backup/cron-jobs/mysql-backup-daily /etc/cron.daily
sudo cp -Rf /backup/cron-jobs/mysql-backup-hourly /etc/cron.hourly

echo -e "\e[33m Задаем права на выполнение скрипту создания резервной копии MySQL: \e[0m"
sudo chown -R root:root /etc/cron.daily/mysql-backup-daily
sudo chmod +x /etc/cron.daily/mysql-backup-daily

sudo chown -R root:root /etc/cron.hourly/mysql-backup-hourly
sudo chmod +x /etc/cron.hourly/mysql-backup-hourly