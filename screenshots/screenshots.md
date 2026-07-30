# Галерея скріншотів

Повний перелік усіх 23 скріншотів з описом, у порядку виконання проєкту.

## Розгортання Suricata

**fig-01 — Перевірка встановлення Suricata**
`suricata -V` та `pacman -Qs suricata` підтверджують встановлену версію 8.0.4 у CachyOS.
![install](../screenshots/fig-01-suricata-install-verification.png)

**fig-02 — Визначення мережевого інтерфейсу**
`ip a` показує активний інтерфейс `wlan0` та IP-адресу системи `192.168.0.209`.
![interface](../screenshots/fig-02-network-interface-wlan0.png)

**fig-03 — Оновлення правил (`suricata-update`)**
Завантаження стандартного набору Emerging Threats (66 106 правил).
![update](../screenshots/fig-03-suricata-update-rules.png)

**fig-04 — Перелік файлів правил**
`ls /var/lib/suricata/rules/` — `classification.config`, `local.rules`, `suricata.rules`.
![rules-dir](../screenshots/fig-04-rules-directory-listing.png)

**fig-05 — Фрагмент `suricata.yaml`**
`default-rule-path` та `rule-files`, які підключають `local.rules`.
![yaml](../screenshots/fig-05-suricata-yaml-config.png)

**fig-06 — Локальні тестові правила**
Вміст `local.rules` у `nano` — усі 12 сигнатур для тестових сценаріїв.
![local-rules](../screenshots/fig-06-local-rules-content.png)

**fig-07 — Перевірка конфігурації**
`suricata -T -c suricata.yaml -v` — 0 помилкових правил, 50195 сигнатур завантажено.
![config-test](../screenshots/fig-07-suricata-config-test.png)

**fig-08 — Запуск Suricata на `wlan0`**
`sudo suricata -c suricata.yaml -i wlan0` — engine started.
![start](../screenshots/fig-08-suricata-start-wlan0.png)

## Сценарій 1–3: мережеві тести

**fig-09 — ICMP-запит з Kali Linux**
`ping 192.168.0.209`.
![ping](../screenshots/fig-09-icmp-ping-kali.png)

**fig-10 — Спрацювання ICMP-правила**
Запис `TEST ICMP rule` у `fast.log`.
![icmp-log](../screenshots/fig-10-fastlog-icmp-detection.png)

**fig-11 — Сканування портів Nmap**
`sudo nmap -sS -Pn -T4 192.168.0.209`.
![nmap](../screenshots/fig-11-nmap-scan-kali.png)

**fig-12 — Спрацювання TCP-правила під час сканування**
Серія записів `TEST TCP scan traffic` у `fast.log`.
![tcp-log](../screenshots/fig-12-fastlog-tcp-scan-detection.png)

**fig-13 — Спроба SSH-підключення**
`ssh` з Kali Linux до CachyOS.
![ssh](../screenshots/fig-13-ssh-connection-attempt.png)

**fig-14 — Спрацювання SSH-правила**
Запис `TEST SSH connection attempt` у `fast.log`.
![ssh-log](../screenshots/fig-14-fastlog-ssh-detection.png)

## Сценарій 4–6: вебатаки та навантаження

**fig-15 — Запуск OWASP Juice Shop у Docker**
`docker run --rm -p 3000:3000 --name juice-shop bkimminich/juice-shop`.
![docker](../screenshots/fig-15-docker-juice-shop-startup.png)

**fig-16 — OWASP Juice Shop у браузері**
Доступність вебдодатка з Kali Linux за `http://192.168.0.209:3000`.
![juice-shop](../screenshots/fig-16-juice-shop-browser.png)

**fig-17 — SQL-injection запит**
`curl` з параметром `' OR 1=1--`.
![sqli-curl](../screenshots/fig-17-sql-injection-curl.png)

**fig-18 — SQL-запит з ключовими словами union select**
Відповідь вебдодатка з помилкою SQLite.
![sqli-union](../screenshots/fig-18-sql-union-select-query.png)

**fig-19 — Спрацювання SQL-правил**
Записи `TEST SQL keyword UNION/SELECT in HTTP URI` у `fast.log`.
![sqli-log](../screenshots/fig-19-fastlog-sql-detection.png)

**fig-20 — Спрацювання правила під час brute force**
Багаторазові записи `TEST Juice Shop login attempt` у `fast.log`.
![bruteforce-log](../screenshots/fig-20-fastlog-bruteforce-login-detection.png)

**fig-21 — Ресурси Suricata до навантаження**
`ps` показує ~2.0% CPU, 7.8% RAM, RSS 615512 KB.
![resources-before](../screenshots/fig-21-resource-usage-before-load.png)

**fig-22 — HTTP-навантаження ApacheBench**
`ab -n 20000 -c 100` — 20 000 запитів, 0 помилок, 221.98 req/sec.
![apachebench](../screenshots/fig-22-apachebench-load-test.png)

**fig-23 — Ресурси Suricata після навантаження**
`ps` показує ~3.0% CPU, 10.2% RAM, RSS 799416 KB.
![resources-after](../screenshots/fig-23-resource-usage-after-load.png)
