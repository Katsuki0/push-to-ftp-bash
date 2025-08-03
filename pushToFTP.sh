#!/bin/bash

ADRESS="ip"
USERNAME="login"
PASSWORD="password"

REMOTE_DIR="path to remote folder"
LOCAL_DIR="path to extraction folder"

if ! command -v lftp &> /dev/null
then
    echo "Ошибка: lftp не установлен. Установите его командой: sudo apt install lftp"
    exit 1
fi

echo "Начинаем загрузку файлов на FTP..."

if ! ls "$LOCAL_DIR"/*.txt &> /dev/null;
then
    echo "Ошибка: Нет .txt файлов для загрузки в директории $LOCAL_DIR"
    exit 1
fi

lftp -u "$USERNAME","$PASSWORD" "$ADRESS" <<EOF
set ftp:ssl-allow no
set sftp:auto-confirm yes
set mirror:use-pget-n 8

cd "$REMOTE_DIR"
lcd "$LOCAL_DIR"

mput -E -O "$REMOTE_DIR" *.txt

bye
EOF

if [ $? -eq 0 ]; then
    echo "Загрузка завершена успешно!"
else
    echo "Ошибка: Произошла ошибка при загрузке файлов."
    exit 1
fi
