# Hotspot Setup

Complete guide to the KDX WiFi hotspot / repeater service.

---

## Overview

This laptop acts as a **WiFi repeater/bridge**. It stays connected to the primary WiFi network (`kdx`) and simultaneously broadcasts a `KDX-Hotspot` access point. Mobile devices connect to `KDX-Hotspot` and get internet through this laptop via NAT.

> **Note:** This uses **AP mode** with a virtual interface, not ad-hoc/IBSS mode.

---

## Hardware Support

| Adapter | Driver | Status |
|---------|--------|--------|
| Realtek RTL8852BE | `rtw89_8852bte` | ✅ Tested |
| Intel AX200/AX210 | `iwlwifi` | ✅ Supported |
| MediaTek MT7921 | `mt7921e` | ✅ Supported |
| Any with `nl80211` | varies | ✅ Likely supported |

Check your adapter:
```bash
lspci -k -nn | grep -A 5 "Network Controller"
iw phy phy0 info | grep "valid interface combinations"
```

---

## Files

| Path | Purpose |
|------|---------|
| `/etc/hostapd/hostapd-wlo1.conf` | AP configuration |
| `/etc/dnsmasq.d/wlo1_ap.conf` | DHCP/DNS for hotspot |
| `/etc/sysctl.d/99-kdx-hotspot.conf` | IPv4 forwarding |
| `/etc/systemd/system/kdx-hotspot.service` | systemd unit |
| `/usr/local/bin/kdx-hotspot-start.sh` | startup script |
| `/usr/local/bin/kdx-hotspot-stop.sh` | cleanup script |

---

## Network Topology

```
[Internet] ← WiFi ← [Router: kdx]
                            │
                            │ wlo1 (managed, 192.168.1.199)
                            │
                    [Laptop: NAT + DHCP]
                            │
                            │ wlo1_ap (AP, 192.168.10.1)
                            │
                    [Mobile / Devices]
                    192.168.10.10 - 100
```

---

## Configuration

### SSID & Password
Edit `/etc/hostapd/hostapd-wlo1.conf`:
```ini
ssid=KDX-Hotspot
wpa_passphrase=kdx12345
channel=2
```

### DHCP Range
Edit `/etc/dnsmasq.d/wlo1_ap.conf`:
```ini
dhcp-range=192.168.10.10,192.168.10.100,12h
dhcp-option=3,192.168.10.1
dhcp-option=6,192.168.10.1
```

---

## Management

```bash
# Start hotspot
sudo systemctl start kdx-hotspot

# Stop hotspot
sudo systemctl stop kdx-hotspot

# Check status
sudo systemctl status kdx-hotspot

# View logs
sudo journalctl -xeu kdx-hotspot

# Restart
sudo systemctl restart kdx-hotspot
```

---

## Verification

```bash
# Check AP is broadcasting
sudo iw dev wlo1_ap info

# Check DHCP leases
sudo cat /var/lib/misc/dnsmasq.leases

# Check NAT rules
sudo iptables -t nat -L POSTROUTING -v

# Verify kdx WiFi still connected
nmcli connection show --active
```

---

## Troubleshooting

| Issue | Fix |
|-------|-----|
| `wlo1_ap` won’t come up | `sudo iw dev wlo1_ap del && sudo iw phy phy0 interface add wlo1_ap type __ap` |
| No internet on mobile | Check NAT rules, verify `kdx` is connected |
| hostapd fails | Run `sudo hostapd -d /etc/hostapd/hostapd-wlo1.conf` for debug |
| MAC conflict | Virtual AP uses `02:00:00:00:00:01`; change if needed |
| Service won’t start | Check `sudo journalctl -xeu kdx-hotspot` |

---

## Rollback

```bash
sudo systemctl disable --now kdx-hotspot
sudo rm /etc/systemd/system/kdx-hotspot.service
sudo rm /usr/local/bin/kdx-hotspot-*.sh
sudo rm /etc/hostapd/hostapd-wlo1.conf
sudo rm /etc/dnsmasq.d/wlo1_ap.conf
sudo rm /etc/sysctl.d/99-kdx-hotspot.conf
sudo iw dev wlo1_ap del
sudo pkill -9 hostapd || true
sudo pkill -9 dnsmasq || true
sudo systemctl daemon-reload
```
