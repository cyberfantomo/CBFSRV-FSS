#!/bin/bash

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

echo "[*] Installing sudo (if missing)..."
apt-get install -y sudo 2>/dev/null

echo "[*] Fixing dependencies..."
apt-get -f install -y

echo "[*] Cleaning..."
apt-get autoremove -y
apt-get clean

echo "[✓] Done"
