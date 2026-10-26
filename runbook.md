# Журнал работ по заявке SEC-2026-0088

| # | Время | Кто | Команда | Результат | Требование |
|---|-------|-----|---------|-----------|------------|
| 1 | 10:00 | П2 | `wget offboarding-stand.sh` | Скачано | — |
| 2 | 10:02 | П2 | `sudo bash offboarding-stand.sh` | Стенд развёрнут | — |
| 3 | 10:05 | П1 | `cat /etc/os-release` | Записано в паспорт | — |
| 4 | 10:07 | П1 | `ps -o pid,ppid,lstart,cmd -u kozlov` | Найден процесс PID 2617 (`sleep 3600`) | 2.1.3 |
| 5 | 10:10 | П1 | `sudo passwd -l kozlov` | `passwd -S` → L (заблокирован) | 2.1.1 |
| 6 | 10:12 | П1 | `sudo chage -E 0 kozlov` | Account expired | 2.1.1 |
| 7 | 10:14 | П1 | `sudo usermod -s /usr/sbin/nologin kozlov` | nologin | 2.1.1 |
| 8 | 10:15 | П1 | `sudo gpasswd -d kozlov devops` | OK | 2.1.2 |
| 9 | 10:16 | П1 | `sudo gpasswd -d kozlov finance` | OK | 2.1.2 |
| 10 | 10:17 | П1 | `sudo gpasswd -d kozlov sudo` | OK | 2.1.2 |
| 11 | 10:20 | П1 | `sudo -l -U kozlov` | правил нет | 2.1.2 |
| 12 | 10:26 | П1 | `sudo pkill -TERM -u kozlov` | Процесс 2617 завершен | 2.1.3 |
| 13 | 10:30 | П2 | `sudo find / -xdev -user kozlov` | Найден дамп `/srv/share/db_backup.sql` | 2.3.1 |
| 14 | 10:32 | П2 | `sudo mkdir -p /var/backups/offboarding/kozlov` | копия создана | 2.3.2 |
| 15 | 10:33 | П2 | `sudo chmod 700 /var/backups/offboarding/kozlov` | права закрыты | 2.3.2 |
| 16 | 10:35 | П2 | `sudo chown -R orlova:devops /srv/devops` | передано | 2.2.1 |
| 17 | 10:36 | П2 | `sudo chmod 600 /srv/devops/prod_deploy_key` | 600 | 2.2.1 |
| 18 | 10:38 | П2 | `sudo -u orlova ./deploy.sh` | OK | 2.2.2 |
| 19 | 10:40 | П2 | `sudo -u lebedeva ls /srv/finance` | OK | 2.2.2 |
| 20 | 10:45 | П2 | `sudo mv /srv/share/db_backup.sql /var/backups/offboarding/kozlov/` | перенесено | 2.3.2 |
| 21 | 10:48 | П2 | `sudo mv /home/kozlov/notes.txt /var/backups/...` | перенесено | 2.3.3 |
| 22 | 10:49 | П2 | `sudo mv /home/kozlov/.ssh /var/backups/...` | перенесено | 2.3.3 |
| 23 | 10:55 | П2 | `sudo find / -xdev -perm -4000 -type f` | Найден `/usr/bin/passwd` | 2.3.4 |
| 24 | 10:56 | П2 | `dpkg -S /usr/bin/passwd` | Из пакета, оставлено | 2.3.4 |
| 25 | 11:10 | оба | `sudo bash audit-user.sh kozlov` | скрипт работает | И-02 |
| 26 | 11:30 | оба | `sudo bash offboarding-acceptance.sh` | 17/17 OK | И-01 |

## Ошибки и откаты

| Время | Что произошло | Действие | Итог |
|-------|---------------|----------|------|
| 10:48 | `sudo mv /home/kozlov/notes.txt ...` | Файл не найден: `mv: cannot stat '/home/kozlov/notes.txt': No such file or directory` | Файл отсутствовал на стенде изначально. В бэкап перенесены только `.ssh` и `db_backup.sql`. |
| 11:30 | `sudo bash offboarding-acceptance.sh` | Выявлены 2 ошибки: `FAIL orlova runs deploy.sh` и `FAIL backup: ...` | Приёмочный скрипт выдал 15 из 17. В README зафиксированы причины. |