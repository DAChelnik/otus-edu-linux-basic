# Жизнь после vagrant up

## Локальный сервер репозитория APT

- Подключиться к виртуальной машине VirtualBox по SSH:

    ```powershell
    vagrant ssh local-apt
    ```

- Выполнить:

    ```powershell
    sudo apt-mirror
    ```

    Дождаться окончания процесса зеркалирования пакетов из удаленных репозиториев в локальную папку нашей системы
- Выполнить сценарий для загрузки каталога CNF и его файлов:

    ```powershell
    sudo bash cnf.sh
    ```

    Этот сценарий создаст папку с именем `archive.ubuntu.com` в текущем рабочем каталоге.
- Скопировать эту папку в папку зеркала:

    ```powershell
    sudo cp -av archive.ubuntu.com  /var/www/html/ubuntu/mirror/
    ```

- Настроить задание cron для автоматического обновления наших локальных репозиториев apt. Запустить crontab -e и добавить следующую команду, которая будет выполняться ежедневно в 1:00 ночи:

    ```powershell
    sudo crontab -e
    00  01  *  *  *  /usr/bin/apt-mirror
    ```
