#!/usr/bin/env bash
# setup-environment.sh
#
# Розгортання лабораторного стенду на CachyOS: встановлення Suricata
# та запуск вразливого вебдодатка OWASP Juice Shop у Docker-контейнері.

echo "== Встановлення Suricata (через AUR) =="
yay -S suricata

echo "== Перевірка версії =="
suricata -V
pacman -Qs suricata

echo "== Оновлення правил виявлення =="
sudo suricata-update

echo "== Перевірка конфігурації без запуску повного аналізу =="
sudo suricata -T -c /etc/suricata/suricata.yaml -v

echo "== Визначення мережевого інтерфейсу =="
ip a
# знайти активний інтерфейс (напр. wlan0) і IP-адресу системи

echo "== Запуск Suricata на інтерфейсі wlan0 =="
sudo suricata -c /etc/suricata/suricata.yaml -i wlan0 &

echo "== Запуск OWASP Juice Shop у Docker =="
sudo docker run --rm -p 3000:3000 --name juice-shop bkimminich/juice-shop

echo "Juice Shop доступний за адресою: http://<CACHYOS_IP>:3000"
echo "Локальні тестові правила редагуються у /var/lib/suricata/rules/local.rules"
echo "Журнал спрацювань: sudo tail -f /var/log/suricata/fast.log"
