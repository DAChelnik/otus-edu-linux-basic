#!/bin/bash/

#	Проверяем, существует ли файл /etc/resolv.conf
#	Проверяем, есть ли права у пользователя на редактирование файла
if [[ ! -e /etc/resolv.conf ]]
then
    echo "Файл /etc/resolv.conf отсутствует"
	exit 1
elif [[ ! -w /etc/resolv.conf ]]
then
	echo "Нет прав на запись файла /etc/resolv.conf"
	echo "Запустите скрипт от имени суперпользователя с помощью sudo"
	exit 1
fi

#	Далее команда grep в файле /etc/resolv.conf
#	сначала исключаем строки начинающиеся с # ( grep -v '^#' )
#		символ ^ (каретка) соответствует пустой строке в начале строки
#		строка «#» будет соответствовать только в том случае, если она встречается в самом начале строки
#	затем фильтруем строки, содержащие слово nameserver ( grep nameserver )
#	затем выводим второй столбец в тексте ( awk '{print $2}' )
#	и полученное значение присваиваем переменной ns
ns=$(cat /etc/resolv.conf  | grep -v '^#' | grep nameserver | awk '{print $2}')
#	Преобразуем переменные в массив для дальнейшего сравнения
ns_array=( $ns )
#	Получим количество DNS-серверов в файле /etc/resolv.conf
#	Если меньше или больше двух — ошибка.
#	Посчитаем кол-во элементов в массиве
if [[ ${#ns_array[@]} != 2 ]]
then
	echo "Количество DNS-серверов в файле /etc/resolv.conf не равно двум"
	exit 1
fi

#	Осуществляем ввод предпочитаемого и альтернативного DNS-серверов
#	Осуществляем проверку корректности ввода IP-адреса
echo
echo "Введите предпочитаемый DNS-сервер"
read DNS_PRIMARY
if [[ $DNS_PRIMARY =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]
then
	if dig @$DNS_PRIMARY -t ns ya.ru +short | grep -qai 'yandex'
	then 
		echo "DNS-сервер" $DNS_PRIMARY "корректный"; 
	else 
		echo "DNS-сервер" $DNS_PRIMARY "некорректен"; 
		exit 1
	fi;
	echo
	echo "Введите альтернативный DNS-сервер"
	read DNS_SECONDARY
	if [[ $DNS_SECONDARY =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]
	then
		if dig @$DNS_SECONDARY -t ns ya.ru +short | grep -qai 'yandex'
		then 
			echo "DNS-сервер" $DNS_SECONDARY "корректный"; 
		else 
			echo "DNS-сервер" $DNS_SECONDARY "некорректен"; 
			exit 1
		fi;
	else
		echo "Это не IP-адрес"
		echo "Попробуйте заново"
		exit 1
	fi
else
	echo "Это не IP-адрес"
	echo "Попробуйте заново"
	exit 1
fi

var=1;
#	Преобразуем переменные DNS-серверов в массив для дальнейшего сравнения
ns_correct="$DNS_PRIMARY $DNS_SECONDARY"
ns_correct_array=( $ns_correct )
if [[ ${ns_array[@]} != ${ns_correct_array[@]} ]]
then
	echo
	echo "Конфигурация не совпадает!"
	echo "текущая:"
	echo -e "\e[31mnameserver" ${ns_array[0]}
	echo -e "nameserver" ${ns_array[1]} "\e[0m"
	echo "должна быть:"
	echo -e "\e[33mnameserver" ${ns_correct_array[0]}
	echo -e "nameserver" ${ns_correct_array[1]} "\e[0m";
	echo
	echo "Перед редактироанием сделаем backup файла /etc/resolv.conf"
	if [[ ! -e /etc/resolv.conf.baсkup ]]
	then
		cp /etc/resolv.conf{,.baсkup}
	else
		echo "Файл /etc/resolv.conf.baсkup существует"
		echo "Удаляем файл"
		rm -f /etc/resolv.conf.baсkup
	fi
	echo
	for i in $ns
	do 
		if [[ $var == 1 ]]
		then
			sed -i "s/$i/$DNS_PRIMARY/" /etc/resolv.conf
		elif [[ $var == 2 ]]
		then
			sed -i "s/$i/$DNS_SECONDARY/" /etc/resolv.conf
		fi
		let "var++"
	done
	echo "Операция выполнена успешно"
else
	echo "Вносить изменения не требуется"
fi
