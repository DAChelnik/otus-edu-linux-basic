#!/bin/bash/

echo "Введите путь до папки"
read DIRECTORY
if [ ! -d "$DIRECTORY" ]
then
	echo "Такого пути не существует"
	exit 2
fi

cd $DIRECTORY
rm -vf *.bak *.backup *.tmp 