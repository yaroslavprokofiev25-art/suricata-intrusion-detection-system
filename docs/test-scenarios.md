# Тестові сценарії

Перелік контрольованих сценаріїв мережевої активності, виконаних з Kali Linux VM
проти CachyOS/Juice Shop для перевірки реакції Suricata.

| № | Сценарій | Джерело | Ціль | Інструмент | Правило Suricata | Очікуваний результат |
|---|---|---|---|---|---|---|
| 1 | ICMP-запит | Kali Linux VM | CachyOS | `ping` | `TEST ICMP rule` | Фіксація ICMP-трафіку в `fast.log` |
| 2 | Сканування портів | Kali Linux VM | CachyOS | `nmap -sS -Pn -T4` | `TEST TCP scan traffic` | Фіксація TCP-активності під час сканування |
| 3 | Спроба SSH-підключення | Kali Linux VM | CachyOS:22 | `ssh` | `TEST SSH connection attempt` | Фіксація звернення до SSH-сервісу |
| 4 | SQL-injection запит | Kali Linux VM | Juice Shop:3000 | `curl` / браузер | `TEST SQL keyword UNION/SELECT` | Виявлення SQL-подібного HTTP-запиту |
| 5 | Багаторазові login-запити (brute force) | Kali Linux VM | Juice Shop:3000 | `curl` (loop) | `TEST Juice Shop login attempt` | Фіксація повторних звернень до endpoint входу |
| 6 | HTTP-навантаження | Kali Linux VM | Juice Shop:3000 | `ApacheBench (ab)` | `TEST HTTP traffic to Juice Shop` | Фіксація великої кількості HTTP-запитів + аналіз ресурсів Suricata |

## Команди відтворення

```bash
# 1. ICMP
ping 192.168.0.209

# 2. Сканування портів
sudo nmap -sS -Pn -T4 192.168.0.209

# 3. SSH-підключення
ssh prkfvy@192.168.0.209

# 4. SQL-injection
curl "http://192.168.0.209:3000/rest/products/search?q=%27%20OR%201%3D1--"
curl "http://192.168.0.209:3000/rest/products/search?q=union%20select"

# 5. Імітація brute force (повторні login-запити)
for i in {1..20}; do
  curl -s -X POST http://192.168.0.209:3000/rest/user/login \
    -H "Content-Type: application/json" \
    -d '{"email":"test@test.com","password":"wrongpass"}'
done

# 6. HTTP-навантаження
ab -n 20000 -c 100 http://192.168.0.209:3000/
```

## Примітка

Усі сценарії виконувались виключно в контрольованому локальному середовищі
(власна ізольована мережа, власні тестові сервіси). Правила Suricata, які
використовувались, — тестові локальні сигнатури (`local.rules`), створені
спеціально для перевірки працездатності IDS, а не для повноцінної
класифікації складних реальних атак.
