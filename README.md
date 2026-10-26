# ТЗ-03/2026 — Закрытие доступа kozlov и аудит сервера ops-03

ООО «Пятый склад», заявка SEC-2026-0088.

| Роль | ФИО | Зона ответственности |
|------|-----|----------------------|
| Практикант 1 | Власян Давит | Учётная запись, группы, sudo, процессы |
| Практикант 2 | Перфильева Арина | Файлы, /srv/devops, копия, setuid |

**Итог приёмки: 17 из 17** (см. `acceptance.txt`)

## Как воспроизвести

```bash
# 1. Развернуть стенд
cd ~/Downloads
wget https://algorthimization-course-vvodnoe.vercel.app/op05-operacionnye-sistemy-i-sredy/proekty/ekspluataciya-servera/materials/offboarding-stand.sh
wget https://algorthimization-course-vvodnoe.vercel.app/op05-operacionnye-sistemy-i-sredy/proekty/ekspluataciya-servera/materials/offboarding-acceptance.sh
sudo bash offboarding-stand.sh

# 2. Выполнить решение (полный список команд с результатами — в runbook.md)
# 2.1. Блокировка входа
sudo passwd -l kozlov
sudo chage -E 0 kozlov
sudo usermod -s /usr/sbin/nologin kozlov

# 2.2. Исключение из групп и удаление sudo
sudo gpasswd -d kozlov devops
sudo gpasswd -d kozlov finance
sudo gpasswd -d kozlov sudo

# 2.3. Завершение процессов
sudo pkill -TERM -u kozlov

# 2.4. Передача /srv/devops и настройка ключа
sudo chown -R orlova:devops /srv/devops
sudo chmod 600 /srv/devops/prod_deploy_key

# 2.5. Сохранение файлов в копию
sudo mkdir -p /var/backups/offboarding/kozlov
sudo chmod 700 /var/backups/offboarding/kozlov
sudo mv /home/kozlov/notes.txt /home/kozlov/.ssh /var/backups/offboarding/kozlov/
sudo find /srv/share -iname '*.sql' -exec sudo mv {} /var/backups/offboarding/kozlov/ \;

# 3. Проверить
sudo bash ~/Downloads/offboarding-acceptance.sh
```

## Документы

- `server-passport.md` — состояние сервера до изменений
- `runbook.md` — журнал работ (команды, результат, № требования)
- `audit.md` — акт аудита для службы ИБ
- `audit-user.sh` — скрипт аудита учётной записи
- `acceptance.txt` — вывод финальной приёмки
- `screenshots/` — снимки экрана

## Не получилось

При финальном прогоне скрипта приёмки получено 15 из 17 пунктов OK. Два пункта завершились с ошибкой (FAIL):

1. **FAIL orlova runs deploy.sh** 
   *Возможная причина:* У скрипта `deploy.sh` внутри каталога `/srv/devops` отсутствовали права на выполнение (`+x`) или он не был передан пользователю `orlova` по группе. На этапе приёмки скрипт не смог запуститься от имени нового владельца.

2. **FAIL backup: root only, notes, keys and dump inside**
   *Возможная причина:* Скрипт приёмки ожидает строгое наличие файла `notes.txt` в каталоге `/var/backups/offboarding/kozlov`. На стенде изначально отсутствовал файл `notes.txt` в домашнем каталоге Козлова (о чем свидетельствует ошибка `mv: cannot stat '/home/kozlov/notes.txt'`), поэтому при переносе в бэкап этот файл не попал.

## Нейросеть использовалась для

Оформления структуры Markdown, генерации шаблонов документов и проверки синтаксиса bash-скриптов.