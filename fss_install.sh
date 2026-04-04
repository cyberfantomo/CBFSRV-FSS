#!/bin/bash
# FSS: Fast Server Start (Debian/Ubuntu)
# https://github.com

set -e

# Colors / Цвета
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' 

echo -e "${GREEN}🚀 FSS: Starting aggressive unlock... / Начинаю жесткую разблокировку...${NC}"

# 1. Stop background services / Остановка фоновых служб
echo -e "${YELLOW}--- Stopping background updates / Останавливаю фоновые обновления...${NC}"
export DEBIAN_FRONTEND=noninteractive
systemctl stop apt-daily.service apt-daily-upgrade.service unattended-upgrades apt-daily.timer apt-daily-upgrade.timer 2>/dev/null || true

# 2. Kill stuck processes / Убийство зависших процессов
echo -e "${YELLOW}--- Killing apt/dpkg processes / Убиваю процессы apt/dpkg...${NC}"
pkill -9 apt 2>/dev/null || true
pkill -9 apt-get 2>/dev/null || true

# 3. Remove locks / Снос блокировок
echo -e "${YELLOW}--- Removing lock files / Удаляю файлы блокировки...${NC}"
rm -f /var/lib/dpkg/lock-frontend /var/lib/dpkg/lock /var/lib/apt/lists/lock /var/cache/apt/archives/lock

# 4. Repair and Update / Починка и обновление
echo -e "${YELLOW}--- Repairing and updating / Исправляю и обновляю пакеты...${NC}"
dpkg --configure -a
apt-get update -y
apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade
apt-get autoremove -y

echo -e "${GREEN}✅ Done! System is ready. / Готово! Система готова к работе.${NC}"
