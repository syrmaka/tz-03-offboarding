#!/bin/bash
# audit-user.sh — аудит учётной записи
# Использование: sudo bash audit-user.sh <username>

set -u
USER="$1"

if [ -z "${USER:-}" ]; then
    echo "Использование: $0 <username>"
    exit 1
fi

if ! id "$USER" >/dev/null 2>&1; then
    echo "Пользователь $USER не найден"
    exit 2
fi

echo "=========================================="
echo " Аудит пользователя: $USER"
echo " Дата: $(date)"
echo "=========================================="

echo ""
echo "--- 1. Группы ---"
id "$USER"
getent group | grep -w "$USER" || echo "(в дополнительных группах не состоит)"

echo ""
echo "--- 2. Правила sudo ---"
sudo -l -U "$USER" 2>/dev/null || echo "(правил нет)"

echo ""
echo "--- 3. Процессы ---"
ps -o pid,ppid,lstart,cmd -u "$USER" 2>/dev/null | grep -v '^\s*PID' || echo "(процессов нет)"

echo ""
echo "--- 4. Файлы вне домашнего каталога ---"
find / -xdev -user "$USER" 2>/dev/null | grep -v "^/home/$USER" || echo "(файлов вне дома нет)"

echo ""
echo "--- 5. Домашний каталог ---"
ls -la "/home/$USER" 2>/dev/null || echo "(домашнего каталога нет)"

echo ""
echo "--- 6. Статус блокировки (passwd -S) ---"
sudo passwd -S "$USER" 2>/dev/null

echo ""
echo "--- 7. Срок действия (chage -l) ---"
sudo chage -l "$USER" 2>/dev/null

echo ""
echo "=========================================="
echo " Аудит завершён"
echo "=========================================="