#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

#  Примечания:
#     В конце каждой команды вы можете увидеть > / dev / null . Это просто подавляет вывод из процессов установки.
#     Если вы хотите увидеть результат при подготовке, просто удалите его.
#     Когда вы пытаетесь установить пакет с помощью команды apt-get install , он всегда запрашивает подтверждение, 
#     флаг -y указывает «да», поэтому он не будет запрашивать подтверждение каждой установки.

#  https://andreyex.ru/ubuntu/kak-ustanovit-gitea-na-ubuntu-18-04/
echo -e "\n"
echo -e "\e[33m Инициализация системы контроля версий Gitea: Git with a cup of tea \e[0m \n"
echo -e "\e[33m Устанавливаем базовые пакеты: \e[0m"

echo -e "\e[33m - SQLite \e[0m"
apt -y install sqlite3 > /dev/null

echo -e "\e[33m - Git \e[0m"
apt -y install git > /dev/null

echo -e "\e[33m Создаём нового системного пользователя git, который будет запускать приложение Gitea \e[0m"
#  Команда создаст нового пользователя и группу с именем git, установит для домашнего каталога значение /home/git
sudo adduser \
   --system \
   --shell /bin/bash \
   --gecos 'Git Version Control' \
   --group \
   --disabled-password \
   --home /home/git \
   git

echo -e "\e[33m Скачиваем бинарный файл Gitea \e[0m"
#  На странице загрузки Gitea находим последнюю версию бинарного файла для нашей архитектуры.
#  В данном случае устанавливаем версию 1.17.2 Если доступна новая версия, измените VERSION переменную в команде ниже.
VERSION=1.20.1
sudo wget -q -O /tmp/gitea https://dl.gitea.io/gitea/${VERSION}/gitea-${VERSION}-linux-amd64

#  Двоичный код Gitea может работать из любого места. Мы будем следовать соглашению и переместим двоичный файл в каталог /usr/local/bin:
sudo mv /tmp/gitea /usr/local/bin

#  Сделаем двоичный исполняемый файл:
sudo chmod +x /usr/local/bin/gitea

echo -e "\e[33m Создаём каталоги и устанавливаем необходимые разрешения \e[0m"
#  Выполним команды ниже, чтобы создать каталоги и установить необходимые разрешения
#  Структура каталогов рекомендована официальной документацией Gitea.
#  Права доступа к каталогу /etc/gitea установлены как 770, чтобы мастер установки мог создать файл конфигурации. После завершения установки мы установим более строгие разрешения.
sudo mkdir -p /var/lib/gitea/{custom,data,indexers,public,log}
sudo chown -R git:git /var/lib/gitea/{data,indexers,log}
sudo chmod -R 750 /var/lib/gitea/{data,indexers,log}
sudo mkdir /etc/gitea
sudo chown root:git /etc/gitea
sudo chmod 770 /etc/gitea


echo -e "\e[33m Создаём системный файл модуля \e[0m"
#  Gitea предоставляет файл модуля Systemd, который уже настроен в соответствии с нашими настройками.
#  Загружаем файл в каталог /etc/systemd/system/
sudo wget -q https://raw.githubusercontent.com/go-gitea/gitea/main/contrib/systemd/gitea.service -P /etc/systemd/system/

echo -e "\e[33m Включаем и запускаем сервис Gitea \e[0m"
sudo systemctl daemon-reload
sudo systemctl enable --now gitea

echo -e "\e[33m Включаем планировщик (Cron) \e[0m"
sudo systemctl enable cron

echo -e "\e[33m Разрешаем трафик через порт 3000 \e[0m"
#  По умолчанию Gitea прослушивает соединения через порт 3000 на всех сетевых интерфейсах.
sudo ufw allow 3000/tcp