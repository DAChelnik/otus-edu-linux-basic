#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

# Примечания:
#   В конце каждой команды вы можете увидеть > / dev / null . Это просто подавляет вывод из процессов установки.
#   Если вы хотите увидеть результат при подготовке, просто удалите его.
#   Когда вы пытаетесь установить пакет с помощью команды apt-get install , он всегда запрашивает подтверждение, 
#   флаг -y указывает «да», поэтому он не будет запрашивать подтверждение каждой установки.

echo -e "\e[33m Регистрируем виртуальный хост, добавляем запись в /etc/hosts \e[0m"

for vhFile in /etc/apache2/sites-available/*.conf
do
    echo -e "\e[33m - $ServerName \e[0m"
    vhConf=${vhFile##*/}
    # регистрируем хост
    sudo a2ensite ${vhConf}
    vhost=${vhConf%.*}
    # Добавляем запись в /etc/hosts
    sudo sed -i "2i${vmip}    ${vhost}" /etc/hosts
done

# Обновляем настройки без перезапуска службы 
sudo systemctl reload apache2

# Перезапускаем Apache (останавливаем, а затем запускаем службу)
sudo service apache2 restart

