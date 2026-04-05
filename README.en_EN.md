## 04.04.2026 | [Русский](/README.md) | [English](/README.en.md)
## Version: v1.0.0

### 🚀 FSS (Fast Server Start) — a highly aggressive script for instant preparation of a fresh **Debian/Ubuntu** VPS.

### 😤 The Problem
You just rented a server, logged in via SSH, and want to install a VPN or Docker, but you get:  
`E: Could not get lock /var/lib/dpkg/lock-frontend - open (11: Resource temporarily unavailable)`  
This happens because the system decided to update itself in the background, making you wait 10+ minutes.

### 😎 The Solution
**FSS** doesn't wait. It "kicks the door down," kills background processes, wipes locks, and updates the system in non-interactive mode. Perfect for automation and fast setup of VPN, RDP, and other services.

### 🛠 Usage (OneClick)
Run on a clean server as **root**:

```bash
bash <(curl -Ls https://raw.githubusercontent.com/cyberfantomo/CBFSRV-FSS/main/fss_install.sh)
```
---

### ⚠️ Disclaimer (For "Proper" Admins)
Yes, this script uses pkill -9 and forcibly removes lock files. This is a "dirty" method designed only for the first run on fresh, empty servers where speed is more important than etiquette. Do not use it on production servers with running databases.

---
