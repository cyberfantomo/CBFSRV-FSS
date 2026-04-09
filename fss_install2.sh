#!/bin/bash
# FSS: Fast Server Start (Debian/Ubuntu)
# https://github.com

set -e

# Colors / Цвета
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' 

echo -e "${GREEN}🚀 FSS: Starting aggressive update... / Запуск агрессивного обновления......${NC}"

echo "[*] Stopping auto updates..."
systemctl stop apt-daily.service apt-daily-upgrade.service unattended-upgrades.service 2>/dev/null
systemctl stop apt-daily.timer apt-daily-upgrade.timer 2>/dev/null

echo "[*] Waiting 10s for apt lock..."

for i in {1..10}; do
    if ! fuser /var/lib/dpkg/lock >/dev/null 2>&1; then
        break
    fi
    sleep 1
done

if fuser /var/lib/dpkg/lock >/dev/null 2>&1; then
    echo "[!] Apt still locked — killing..."
    killall apt apt-get 2>/dev/null
fi

echo "[*] Fixing dpkg..."
dpkg --configure -a

echo "[*] Removing broken backports (if any)..."
grep -rl "bullseye-backports" /etc/apt/ 2>/dev/null | while read f; do
    sed -i '/bullseye-backports/s/^/#/' "$f"
done

echo "[*] Updating..."
apt-get update

echo "[*] Upgrading..."
DEBIAN_FRONTEND=noninteractive apt-get upgrade -y

echo "[*] Installing curl/wget if missing..."
command -v curl >/dev/null 2>&1 || apt-get install -y curl
command -v wget >/dev/null 2>&1 || apt-get install -y wget

echo "[*] Installing sudo (if missing)..."
command -v sudo >/dev/null 2>&1 || apt-get install -y sudo

echo "[*] Fixing dependencies..."
apt-get -f install -y

echo "[*] Cleaning..."
apt-get autoremove -y
apt-get clean

echo -e "${GREEN}✅ Done! System is ready. / Готово! Система готова к работе.${NC}"
