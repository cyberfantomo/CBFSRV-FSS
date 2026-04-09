## 04.04.2026 | [Русский](/README.md) | [English](/README.en_EN.md)
## Version: v1.0.0

### 🚀 FSS (Fast Server Start) — a highly aggressive script for quickly preparing a fresh Debian/Ubuntu VPS for use. 

### 😤 Problem
You’ve just rented a server, logged in via SSH, and want to install VPN or Docker, etc., but instead you get something like:
```
E: Could not get lock /var/lib/dpkg/lock-frontend - open (11: Resource temporarily unavailable).
```
At this moment, the system is running background updates, locking dpkg/apt, breaking dependencies, or leaving packages in an inconsistent state. Sometimes this can take 10+ minutes — or never finish at all.

### 😎 Solution
**FSS** doesn’t wait. It “kicks the door in”: stops background update services, waits for locks to be released, and if necessary kills stuck processes. Then it restores the dpkg state, fixes dependencies, and updates the system in non-interactive mode.
- Also installs essential utilities often missing on fresh servers (sudo, curl, wget)
- Intended as a first step on a fresh server — instead of running ```apt update && apt upgrade```
- Perfect for automation and quick setup of servers for VPN, RDP, and more

### ✅ Compatibility
Tested and works reliably on:
- Debian 12
- Ubuntu 24

It will likely work on other versions as well, but this has not been tested.

### 🛠 Usage (OneClick)
Run on a clean server as **root**:

```bash
bash <(curl -Ls https://raw.githubusercontent.com/cyberfantomo/CBFSRV-FSS/main/fss_install2.sh 2>/dev/null || wget -qO- https://raw.githubusercontent.com/cyberfantomo/CBFSRV-FSS/main/fss_install2.sh)
```
---

### ⚠️ Disclaimer (for “proper” admins)
Yes, this script may use forceful methods (pkill, etc.) if the system is stuck or locked. It is intended for initial setup on fresh, empty servers where speed matters more than elegance. Do not use it on production servers with running databases.

---
