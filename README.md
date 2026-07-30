# Suricata IDS Lab: Deployment & Effectiveness Analysis

Розгортання та практичне тестування мережевої системи виявлення вторгнень
(Suricata) у лабораторному середовищі: аналіз реакції IDS на сканування
портів, SQL-injection, brute force та HTTP-навантаження.

## Stack
CachyOS (Arch Linux) · Suricata 8.0.4 · Kali Linux (VM) · OWASP Juice Shop · Docker · Nmap · ApacheBench

## Architecture

Детальний опис: [`docs/architecture.md`](docs/architecture.md)

CachyOS хостить Suricata (моніторинг інтерфейсу `wlan0`) та вразливий
вебдодаток OWASP Juice Shop у Docker. Kali Linux VM виступає ізольованим
джерелом тестової атакувальної активності.

## Тестові сценарії та результати

| # | Сценарій | Інструмент | Правило Suricata | Результат |
|---|---|---|---|---|
| 1 | ICMP-запит | `ping` | `TEST ICMP rule` | Зафіксовано |
| 2 | Сканування портів | `nmap` | `TEST TCP scan traffic` | Зафіксовано |
| 3 | SSH-підключення | `ssh` | `TEST SSH connection attempt` | Зафіксовано |
| 4 | SQL-injection | `curl` | `TEST SQL keyword UNION/SELECT` | Зафіксовано |
| 5 | Brute-force login | `curl` (loop) | `TEST Juice Shop login attempt` | Зафіксовано |
| 6 | HTTP-навантаження (20k запитів) | `ApacheBench` | `TEST HTTP traffic to Juice Shop` | Зафіксовано, CPU 2.0%→3.0%, RAM 7.8%→10.2% |

Повний перелік сценаріїв і команд: [`docs/test-scenarios.md`](docs/test-scenarios.md)
Критерії та деталі оцінювання: [`docs/evaluation-criteria.md`](docs/evaluation-criteria.md)

## Ключові висновки

- 6/6 тестових сценаріїв успішно виявлено через журнал `fast.log`
- Ресурсне навантаження Suricata залишалось стабільним під HTTP-навантаженням (20 000 запитів, 0 помилок, ~222 req/sec)

## Структура репозиторію

```
├── config/
│   ├── local.rules              # усі 12 тестових правил Suricata
│   └── suricata.yaml.snippet    # фрагмент конфігурації (rule-files)
├── docs/
│   ├── architecture.md          # архітектура стенду
│   ├── test-scenarios.md        # 6 сценаріїв + команди відтворення
│   └── evaluation-criteria.md   # критерії та результати оцінювання
├── logs/
│   └── fast.log.sample          # вирізка реальних спрацювань
├── screenshots/                 # 23 скріншоти виконання (fig-01 … fig-23)
├── scripts/
│   ├── setup-environment.sh     # встановлення Suricata + Juice Shop
│   └── run-tests.sh             # усі команди тестування одним файлом
└── thesis/                      # повний текст дипломного проєкту
```

## Відтворення

```bash
# 1. На CachyOS: встановити Suricata та запустити Juice Shop
bash scripts/setup-environment.sh

# 2. Скопіювати config/local.rules у /var/lib/suricata/rules/local.rules

# 3. На Kali Linux VM: виконати тестові сценарії
bash scripts/run-tests.sh

# 4. Перевірити журнал на CachyOS
sudo tail -f /var/log/suricata/fast.log
```

## Повний звіт

Повний текст дипломного проєкту (теорія IDS, класифікація, порівняння
Snort/Suricata/Zeek/Wazuh, детальний практичний розділ) — у папці [`thesis/`](thesis).
