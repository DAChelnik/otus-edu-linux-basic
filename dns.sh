#!/bin/bash/

# переменные правильных NS
NS1_CORRECT="172.31.96.1"
NS2_CORRECT="10.23.1.1"

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
ns_correct="$NS1_CORRECT $NS2_CORRECT"
echo $ns;
echo $ns_correct;

if [[ $ns != $ns_correct ]] ; then
	echo "Конфигурация не совпадает"
else
	echo "Вносить изменения не требуется"
fi
