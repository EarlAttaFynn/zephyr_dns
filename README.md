# Zephyr DNS (AdGuard Home + Unbound)

A privacy-focused, recursive DNS filtering stack running on Docker.

**Architecture:** `Clients` ➔ `AdGuard Home` (Filtering) ➔ `Unbound` (Recursive Resolution) ➔ `Root Servers`

### 🏗️ Network Flow

1.  **Host IP:** `<STATIC_IP>` (e.g., `192.168.1.10`)
2.  **AdGuard Home:** Listens on Port `53` (TCP/UDP). Handles blocklists and client management.
3.  **Unbound:** Listens on `127.0.0.1:5335`. Handles DNSSEC and recursive lookups.

-----

### 🚀 Quick Start

```bash
# Clone and enter directory
git clone <repository_url>
cd unbound_dns

# Start the stack
docker-compose up -d

# Check status
docker-compose ps

# Update containers (Monthly)
docker-compose pull && docker-compose up -d
```

### 📂 Configuration

  * **AdGuard Dashboard:** `http://<HOST_IP>:3000`
  * **AdGuard Config:** `./adguard_conf/AdGuardHome.yaml`
  * **Unbound Config:** Managed internally by the Docker image.

**Router Settings:**
To force network-wide use, configure your router's **LAN DNS** settings:

  * **IPv4 DNS Relay:** `Disabled` (if applicable)
  * **LAN DNS Mode:** `Statically Configured`
  * **Primary DNS:** `<HOST_IP>`
  * **Secondary DNS:** `<HOST_IP>` (or `0.0.0.0` / Alias IP)

-----

### 🛠️ Debugging & Maintenance

**1. Check Logs**

```bash
# View live logs for AdGuard
docker logs -f --tail 50 adguard

# View live logs for Unbound
docker logs -f --tail 50 unbound
```

**2. Test DNS Resolution**

```bash
# Test Unbound directly (Bypass AdGuard)
dig @127.0.0.1 -p 5335 google.com

# Test AdGuard (Simulate a client)
dig @<HOST_IP> google.com
```

**3. Emergency Network Fix**
If the static IP fails and you need to reset networking on the host:

```bash
# Connect monitor/keyboard and run:
sudo nmtui
```
