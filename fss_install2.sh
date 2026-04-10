#!/bin/bash
# FSS: Fast Server Start (Debian/Ubuntu)
# https://github.com/cyberfantomo/CBFSRV-FSS

set -e

# Colors / Цвета
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' 

echo -e "${GREEN}FSS: Запуск агрессивного обновления... / Starting aggressive update...${NC}"

echo "[*] Killing cloud-init (fast mode)..."
systemctl stop cloud-init cloud-init-local cloud-config cloud-final 2>/dev/null || true
pkill -f cloud-init 2>/dev/null || true

echo "[*] Stopping auto updates..."
systemctl stop apt-daily.service apt-daily-upgrade.service unattended-upgrades.service 2>/dev/null || true
systemctl stop apt-daily.timer apt-daily-upgrade.timer 2>/dev/null || true

echo "[*] Waiting 10s for apt lock..."
for i in {1..10}; do
    if ! fuser /var/lib/dpkg/lock >/dev/null 2>&1 && \
       ! fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1; then
        break
    fi
    sleep 1
done

if fuser /var/lib/dpkg/lock >/dev/null 2>&1 || \
   fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1; then
    echo "[!] Apt still locked — killing..."
    killall apt apt-get dpkg 2>/dev/null || true
fi

echo "[*] Waiting for dpkg after kill..."
for i in {1..10}; do
    if ! fuser /var/lib/dpkg/lock >/dev/null 2>&1 && \
       ! fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1; then
        break
    fi
    sleep 1
done

echo "[*] Ensuring no apt/dpkg processes remain..."

set +e
for i in {1..3}; do
    pkill -f apt 2>/dev/null
    pkill -f unattended 2>/dev/null
    sleep 1
done
set -e

echo "[*] Fixing dpkg..."
dpkg --configure -a || true

echo "[*] Fixing broken packages (pre)..."
apt-get -f install -y || true

echo "[*] Removing broken backports (hard)..."
grep -rl "bullseye-backports" /etc/apt/ 2>/dev/null | while read f; do
    sed -i '/bullseye-backports/d' "$f"
done

echo "[*] Updating..."
apt-get update || true

echo "[*] Fixing broken packages (after update)..."
apt-get -f install -y || true

echo "[*] Upgrading..."
DEBIAN_FRONTEND=noninteractive apt-get upgrade -y || true

echo "[*] Second upgrade pass..."
apt-get upgrade -y || true

echo "[*] Installing curl/wget if missing..."
command -v curl >/dev/null 2>&1 || apt-get install -y curl || true
command -v wget >/dev/null 2>&1 || apt-get install -y wget || true

echo "[*] Installing sudo (if missing)..."
command -v sudo >/dev/null 2>&1 || apt-get install -y sudo || true

echo "[*] Final repair pass..."
dpkg --configure -a || true
apt-get -f install -y || true

echo "[*] Cleaning..."
apt-get autoremove -y || true
apt-get clean || true

echo -e "${GREEN}✅ Done! System is ready. / Готово! Система готова к работе.${NC}"
