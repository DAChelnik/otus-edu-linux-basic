#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

# Примечания:
#   В конце каждой команды вы можете увидеть > / dev / null . Это просто подавляет вывод из процессов установки.
#   Если вы хотите увидеть результат при подготовке, просто удалите его.
#   Когда вы пытаетесь установить пакет с помощью команды apt-get install , он всегда запрашивает подтверждение, 
#   флаг -y указывает «да», поэтому он не будет запрашивать подтверждение каждой установки.

# Установка и настройка платформы BookStack на виртуальный сервер.
#   BookStack - это платформа с открытым исходным кодом для создания документации и вики-контента для пользователей.
#   Платформа построена на стеке LAMP или LEMP и отлично подходит для создания документов для любого проекта. 
#   Интерфейс BookStack прост и понятен. Редактор страниц имеет простой интерфейс WYSIWYG.

#   https://1cloud.ru/help/linux/ustanovka-i-nastroika-bookstack-na-ubuntu?ysclid=lduln0ctm45681850

dfsdfsfsdfsdafa="$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13)"
echo -e "$ServerAdmin"
echo -e "$dfsdfsfsdfsdafa"
echo -e ""


# Fetch domain to use from first provided parameter,
# Otherwise request the user to input their domain

# Get the current machine IP address
CURRENT_IP=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')

# Install core system packages
export DEBIAN_FRONTEND=noninteractive
add-apt-repository universe
apt-get update
apt-get install -y git unzip apache2 php7.4 curl php7.4-fpm php7.4-curl php7.4-mbstring php7.4-ldap \
php7.4-tidy php7.4-xml php7.4-zip php7.4-gd php7.4-mysql mysql-server-8.0 libapache2-mod-php7.4
echo -e "\e[33m - 1 **************************\e[0m"
echo -e "\n"


# Set up database
DB_PASS="$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13)"
sudo mysql -u root --execute="CREATE DATABASE bookstack;"
sudo mysql -u root --execute="CREATE USER 'bookstack'@'localhost' IDENTIFIED WITH mysql_native_password BY '$DB_PASS';"
sudo mysql -u root --execute="GRANT ALL ON bookstack.* TO 'bookstack'@'localhost';FLUSH PRIVILEGES;"
echo -e "\e[33m -2 ***************************\e[0m"
echo -e "\n"


# Загрузка BookStack и настройка окружения
cd /var/www || exit
sudo git clone https://github.com/BookStackApp/BookStack.git --branch release --single-branch bookstack
BOOKSTACK_DIR="/var/www/bookstack"
cd $BOOKSTACK_DIR || exit
echo -e "\e[33m -3 ***************************\e[0m"
echo -e "\n"


# Install composer
EXPECTED_CHECKSUM="$(php -r 'copy("https://composer.github.io/installer.sig", "php://stdout");')"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]
then
    >&2 echo 'ERROR: Invalid composer installer checksum'
    sudo rm composer-setup.php
    exit 1
fi
echo -e "\e[33m -4 ***************************\e[0m"
echo -e "\n"


sudo php composer-setup.php --quiet
sudo rm composer-setup.php
echo -e "\e[33m -5 ***************************\e[0m"
echo -e "\n"


# Move composer to global installation
sudo mv composer.phar /usr/local/bin/composer
echo -e "\e[33m -6 ***************************\e[0m"
echo -e "\n"


# Install BookStack composer dependencies
export COMPOSER_ALLOW_SUPERUSER=1
sudo php /usr/local/bin/composer install --no-dev --no-plugins
echo -e "\e[33m -7 ***************************\e[0m"
echo -e "\n"


# Copy and update BookStack environment variables
sudo cp .env.example .env
sudo sed -i.bak "s@APP_URL=.*\$@APP_URL=http://$DOMAIN@" .env
sudo sed -i.bak 's/DB_DATABASE=.*$/DB_DATABASE=bookstack/' .env
sudo sed -i.bak 's/DB_USERNAME=.*$/DB_USERNAME=bookstack/' .env
sudo sed -i.bak "s/DB_PASSWORD=.*\$/DB_PASSWORD=$DB_PASS/" .env
echo -e "\e[33m -8 ***************************\e[0m"
echo -e "\n"


# Generate the application key
sudo php artisan key:generate --no-interaction --force
# Migrate the databases
sudo php artisan migrate --no-interaction --force
echo -e "\e[33m***************************\e[0m"
echo -e "\n"


# Set file and folder permissions
sudo chown www-data:www-data -R bootstrap/cache public/uploads storage && chmod -R 755 bootstrap/cache public/uploads storage
echo -e "\e[33m***************************\e[0m"
echo -e "\n"


# Set up apache
sudo a2enmod rewrite
sudo a2enmod php7.4
echo -e "\e[33m***************************\e[0m"
echo -e "\n"

#   Настроим конфигурационный файл Apache2 для BookStack, который будет контролировать доступ пользователей к содержимому BookStack
sudo cat >/etc/apache2/sites-available/bookstack.conf <<EOL
<VirtualHost *:80>
	ServerName ${DOMAIN}
	ServerAdmin ${ServerAdmin}
	DocumentRoot /var/www/bookstack/public/
    <Directory /var/www/bookstack/public/>
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted
        <IfModule mod_rewrite.c>
            <IfModule mod_negotiation.c>
                Options -MultiViews -Indexes
            </IfModule>
            RewriteEngine On
            # Handle Authorization Header
            RewriteCond %{HTTP:Authorization} .
            RewriteRule .* - [E=HTTP_AUTHORIZATION:%{HTTP:Authorization}]
            # Redirect Trailing Slashes If Not A Folder...
            RewriteCond %{REQUEST_FILENAME} !-d
            RewriteCond %{REQUEST_URI} (.+)/$
            RewriteRule ^ %1 [L,R=301]
            # Handle Front Controller...
            RewriteCond %{REQUEST_FILENAME} !-d
            RewriteCond %{REQUEST_FILENAME} !-f
            RewriteRule ^ index.php [L]
        </IfModule>
    </Directory>
	ErrorLog \${APACHE_LOG_DIR}/error.log
	CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOL
echo -e "\e[33m***************************\e[0m"
echo -e "\n"


sudo a2dissite 000-default.conf
sudo a2ensite bookstack.conf
echo -e "\e[33m***************************\e[0m"
echo -e "\n"


# Restart apache to load new config
sudo systemctl restart apache2
echo -e "\e[33m***************************\e[0m"
echo -e "\n"

echo -e "\e[33m Брандмауэр UFW \e[0m"
echo -e "\e[33m - открываем необходимые порты для работы Apache \e[0m"
sudo ufw allow 'Apache Full' > /dev/null
echo -e "\n"

echo ""
echo -e "\e[33m***************************\e[0m"
echo -e "\n"
echo "Setup Finished, Your BookStack instance should now be installed."
echo "You can login with the email 'admin@admin.com' and password of 'password'"
echo "MySQL was installed without a root password, It is recommended that you set a root MySQL password."
echo ""
echo "You can access your BookStack instance at: http://$CURRENT_IP/ or http://$DOMAIN/"