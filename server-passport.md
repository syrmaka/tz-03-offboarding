# Паспорт сервера ops-03 (до изменений)

## Система
- Версия: Ubuntu 24.04 LTS
- Команда: `cat /etc/os-release`

## Учётные записи и группы

| Логин | UID | GID | Дом. каталог | Оболочка | Группы |
|-------|-----|-----|--------------|----------|--------|
| kozlov | 1001 | 1001 | /home/kozlov | /bin/bash | kozlov, devops, finance, sudo |
| orlova | 1002 | 1002 | /home/orlova | /bin/bash | orlova, devops |
| lebedeva | 1003 | 1003 | /home/lebedeva | /bin/bash | lebedeva, finance |

Команды: `getent passwd kozlov orlova lebedeva`, `id kozlov`, `getent group devops finance sudo`

## Процессы

| PID | PPID | Пользователь | Команда | Запущен |
|-----|------|--------------|---------|---------|
| 2617 | 1333 | kozlov | `sleep 3600` | Mon Oct 26 15:07:45 2026 |

Команда: `ps -o pid,ppid,lstart,cmd -u kozlov`

## Каталоги

| Каталог | Владелец | Группа | Права | Содержимое |
|---------|----------|--------|-------|------------|
| /srv/devops | kozlov | devops | 755 | скрипты выкладки, prod_deploy_key |
| /srv/finance | lebedeva | finance | 755 | платёжные документы |
| /srv/share | root | root | 777 | общая папка, db_backup.sql |
| /home/kozlov | kozlov | kozlov | 700 | notes.txt, .ssh |

Команды: `ls -ld`, `ls -lR /srv/devops`, `ls -lR /srv/finance`, `ls -lR /srv/share`, `ls -la /home/kozlov`

## setuid (исходный)
/usr/bin/passwd
/usr/bin/sudo
/usr/bin/su
... (и другие стандартные программы)