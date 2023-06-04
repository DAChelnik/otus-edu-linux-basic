#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

# Примечания:
#   В конце каждой команды вы можете увидеть > / dev / null . Это просто подавляет вывод из процессов установки.
#   Если вы хотите увидеть результат при подготовке, просто удалите его.
#   Когда вы пытаетесь установить пакет с помощью команды apt-get install , он всегда запрашивает подтверждение, 
#   флаг -y указывает «да», поэтому он не будет запрашивать подтверждение каждой установки.
echo -e "\n"
echo -e "\e[33m Инициализация системы аналитики и электронного обучения \e[0m \n"
echo -e "\e[33m Устанавливаем базовые пакеты: \e[0m"

echo -e "\e[33m - Apache сервер \e[0m"
apt-get -y install apache2 > /dev/null

echo -e "\e[33m - PHP версии $PHPVERSION \e[0m"
apt-get -y install php$PHPVERSION libapache2-mod-php$PHPVERSION > /dev/null

echo -e "\e[33m - необходимые PHP расширения \e[0m"
apt-get -y install php$PHPVERSION-json > /dev/null
apt-get -y install php$PHPVERSION-curl > /dev/null
apt-get -y install php$PHPVERSION-mysql > /dev/null
apt-get -y install php$PHPVERSION-xml > /dev/null
apt-get -y install php$PHPVERSION-xmlrpc > /dev/null
apt-get -y install php$PHPVERSION-common > /dev/null
apt-get -y install php$PHPVERSION-sqlite3 > /dev/null
apt-get -y install php$PHPVERSION-intl > /dev/null
apt-get -y install php$PHPVERSION-mbstring > /dev/null
apt-get -y install php$PHPVERSION-gd > /dev/null
apt-get -y install php$PHPVERSION-zip > /dev/null
apt-get -y install php$PHPVERSION-imap > /dev/null
apt-get -y install php$PHPVERSION-ldap> /dev/null
apt-get -y install php$PHPVERSION-apcu > /dev/null
apt-get -y install php$PHPVERSION-cli > /dev/null
apt-get -y install php$PHPVERSION-memcached > /dev/null
apt-get -y install php$PHPVERSION-pgsql > /dev/null
apt-get -y install php$PHPVERSION-imagick > /dev/null

sudo sed -i 's/max_execution_time = .*/max_execution_time = 360/' /etc/php/$PHPVERSION/apache2/php.ini
sudo sed -i 's/memory_limit = .*/memory_limit = 512M/' /etc/php/$PHPVERSION/apache2/php.ini
sudo sed -i 's/upload_max_filesize = .*/upload_max_filesize = 1024M/' /etc/php/$PHPVERSION/apache2/php.ini
#   sed -i 's/post_max_size = .*/post_max_size = 64M/' /etc/php/$PHPVERSION/apache2/php.ini
#   sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/$PHPVERSION/apache2/php.ini
#   sed -i "s/display_errors = .*/display_errors = On/" /etc/php/$PHPVERSION/apache2/php.ini
sudo sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf

# Перезапускаем Apache (останавливаем, а затем запускаем службу)
sudo service apache2 restart

echo -e "\e[33m Включаем Apache mod rewrite \e[0m"
sudo a2enmod rewrite > /dev/null
# Перезапускаем Apache (останавливаем, а затем запускаем службу)
sudo service apache2 restart

echo -e "\e[33m Брандмауэр UFW \e[0m"
echo -e "\e[33m - открываем необходимые порты для работы Apache \e[0m"
sudo ufw allow 'Apache Full' > /dev/null
echo -e "\n"


echo -e "\e[33m Удаляем все существующие виртуальные хосты \e[0m"
sudo rm -rf /etc/apache2/sites-available/*.conf
sudo rm -rf /etc/apache2/sites-enabled/*.conf

echo -e "\e[33m Добавляем конфигурацию для хоста по умолчанию - 000-default \e[0m"
echo "<VirtualHost *:80>" > /etc/apache2/sites-available/000-default.conf
echo "  ServerAdmin webmaster@localhost" >> /etc/apache2/sites-available/000-default.conf
echo "	DocumentRoot /var/www/html" >> /etc/apache2/sites-available/000-default.conf
echo "	ErrorLog ${APACHE_LOG_DIR}/error.log" >> /etc/apache2/sites-available/000-default.conf
echo "	CustomLog ${APACHE_LOG_DIR}/access.log combined" >> /etc/apache2/sites-available/000-default.conf
echo "</VirtualHost>" >> /etc/apache2/sites-available/000-default.conf

echo -e "\e[34m Добавляем конфигурацию для хоста по протоколу HTTPS - default-ssl.conf \e[0m"
echo "<IfModule mod_ssl.c>" > /etc/apache2/sites-available/default-ssl.conf
echo "  <VirtualHost _default_:443>" >> /etc/apache2/sites-available/default-ssl.conf
echo "    ServerAdmin webmaster@localhost" >> /etc/apache2/sites-available/default-ssl.conf
echo "    DocumentRoot /var/www/html" >> /etc/apache2/sites-available/default-ssl.conf
echo "    ErrorLog ${APACHE_LOG_DIR}/error.log" >> /etc/apache2/sites-available/default-ssl.conf
echo "    CustomLog ${APACHE_LOG_DIR}/access.log combined" >> /etc/apache2/sites-available/default-ssl.conf
echo "    SSLEngine on" >> /etc/apache2/sites-available/default-ssl.conf
echo "    SSLCertificateFile	/etc/ssl/certs/ssl-cert-snakeoil.pem" >> /etc/apache2/sites-available/default-ssl.conf
echo "    SSLCertificateKeyFile /etc/ssl/private/ssl-cert-snakeoil.key" >> /etc/apache2/sites-available/default-ssl.conf
echo "    #SSLCertificateChainFile /etc/apache2/ssl.crt/server-ca.crt" >> /etc/apache2/sites-available/default-ssl.conf
echo "    <FilesMatch \"\.(cgi|shtml|phtml|php)$\">" >> /etc/apache2/sites-available/default-ssl.conf
echo "      SSLOptions +StdEnvVars" >> /etc/apache2/sites-available/default-ssl.conf
echo "    </FilesMatch>" >> /etc/apache2/sites-available/default-ssl.conf
echo "    <Directory /usr/lib/cgi-bin>" >> /etc/apache2/sites-available/default-ssl.conf
echo "      SSLOptions +StdEnvVars" >> /etc/apache2/sites-available/default-ssl.conf
echo "    </Directory>" >> /etc/apache2/sites-available/default-ssl.conf
echo "  </VirtualHost>" >> /etc/apache2/sites-available/default-ssl.conf
echo "</IfModule>" >> /etc/apache2/sites-available/default-ssl.conf

