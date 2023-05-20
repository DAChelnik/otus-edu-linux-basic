#!/bin/bash/

DNS_PRIMARY="77.88.8.8"
DNS_SECONDARY="77.88.8.1"

if [[ ! -e /etc/resolv.conf ]]; then # проверяем, существует ли файл
	echo "Файл /etc/resolv.conf отсутствует"
	exit 1
elif [ ! -w /etc/resolv.conf ] ; then # проверяем, есть ли права у пользователя на редактирование
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
ns_correct="$DNS_PRIMARY $DNS_SECONDARY"
#	Преобразуем переменные в массив для дальнейшего сравнения
ns_array=( $ns )
ns_correct_array=( $ns_correct )
#	Получим количество DNS-серверов в файле /etc/resolv.conf
#	Если меньше или больше двух — ошибка.
#	Подпсчитаем кол-во элементов в массиве
if [[ ${#ns_array[@]} != 2 ]] ; then
	echo "Количество DNS-серверов в файле /etc/resolv.conf не равно двум"
	exit 1
fi

var=1;
if [[ ${ns_array[@]} != ${ns_correct_array[@]} ]] ; then
	echo "Конфигурация не совпадает!"
	echo
	echo "текущая:"
	echo -e "\e[31mnameserver" ${ns_array[0]};
	echo -e "nameserver" ${ns_array[1]} "\e[0m";
	echo
	echo "должна быть:"
	echo -e "\e[33mnameserver" ${ns_correct_array[0]};
	echo -e "nameserver" ${ns_correct_array[1]} "\e[0m";
	echo
	echo "Перед редактироанием сделаем backup файла /etc/resolv.conf"
	cp /etc/resolv.conf{,.baсkup}
	echo
	for i in $ns; do ptr=$(host $i | sed 's/Name: //' | sed 's/ .*//g' | head -n 1)
		if [[ $var == 1 ]]; then
			sed -i "s/$i/$DNS_PRIMARY/" /etc/resolv.conf
		elif [[ $var == 2 ]]; then
			sed -i "s/$i/$DNS_SECONDARY/" /etc/resolv.conf
		fi
		let "var++";
	done
else
	echo "Вносить изменения не требуется"
fi
