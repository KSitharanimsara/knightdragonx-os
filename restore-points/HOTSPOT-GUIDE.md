# KDX WiFi Hotspot — Build Log & Restore Guide

**Stable Point Date:** 2026-07-26  
**Kernel:** Linux 6.12.x  
**WiFi Adapter:** Realtek RTL8852BE-VT (`rtw89_8852bte`)  
**Interface:** `wlo1` (client) + `wlo1_ap` (AP, virtual)  
**Hotspot SSID:** `KDX-Hotspot`  
**Hotspot Password:** `kdx12345`  
**Client Subnet:** `192.168.10.0/24`  
**Gateway:** `192.168.10.1`  
**DHCP Range:** `192.168.10.10` – `192.168.10.100`  
**Internet Source:** `kdx` WiFi connection (`192.168.1.199` via `192.168.1.1`)  
**DNS:** `8.8.8.8`, `8.8.4.4`  
**Channel:** 2 (2417 MHz, 20 MHz)  

---

## 1. What This Setup Does

This laptop acts as a **WiFi repeater/bridge**. It stays connected to the `kdx` WiFi network for internet, and simultaneously broadcasts a `KDX-Hotspot` access point on a separate virtual interface (`wlo1_ap`). Mobile devices connect to `KDX-Hotspot` and get internet through this laptop via NAT.

This is **not** ad-hoc/IBSS mode — the RTL8852BE driver does not support IBSS. It uses **AP mode** with a virtual interface.

---

## 2. Hardware / Driver Constraints

- **Adapter:** Realtek RTL8852BE-VT PCIe 802.11ax
- **Driver:** `rtw89_8852bte`
- **Phy:** `phy0`
- **Supported modes:** managed + AP (one each, same channel)
- **Unsupported modes:** ad-hoc (IBSS), P2P-GO used as persistent AP
- **MAC conflict workaround:** virtual AP interface gets a locally administered MAC (`02:00:00:00:00:01`) because the driver reuses the physical MAC on both managed and AP vifs

---

## 3. Files Created / Modified

### System configs
| Path | Purpose |
|------|---------|
| `/etc/hostapd/hostapd-wlo1.conf` | hostapd AP config |
| `/etc/dnsmasq.d/wlo1_ap.conf` | dnsmasq DHCP/DNS for hotspot subnet |
| `/etc/sysctl.d/99-kdx-hotspot.conf` | IPv4 forwarding (`net.ipv4.ip_forward=1`) |
| `/etc/systemd/system/kdx-hotspot.service` | systemd unit for hotspot |
| `/usr/local/bin/kdx-hotspot-start.sh` | hotspot startup script |
| `/usr/local/bin/kdx-hotspot-stop.sh` | hotspot cleanup script |

### iptables NAT rules (runtime, not persisted)
- `POSTROUTING -o wlo1 -j MASQUERADE`
- `FORWARD -i wlo1 -o wlo1_ap -m state RELATED,ESTABLISHED -j ACCEPT`
- `FORWARD -i wlo1_ap -o wlo1 -j ACCEPT`

### SDDM theme (updated in same session)
| Path | Change |
|------|--------|
| `/usr/share/sddm/themes/Corners/theme.conf` | Colors switched to KDX branding (`#FF0033` red, white text) |
| `/usr/share/sddm/themes/Corners/backgrounds/bg.png` | Replaced with `kdx_wallpaper.png` |
| `/usr/share/sddm/themes/Corners/components/PowerPanel.qml` | Icon overlay reverted to `config.PopupBgColor` |

### Hyprland configs (updated in same session)
| Path | Change |
|------|--------|
| `/home/kdx/.config/hypr/windowrules.conf` | Added default window size rules for browsers, terminals, file managers, etc. |
| `/home/kdx/.config/hypr/userprefs.conf` | Cleaned — window rules moved to `windowrules.conf` |
| `/home/kdx/.config/hypr/hyprlock/theme.conf` | Removed battery status label |

---

## 4. Build Steps (Exact Commands)

```bash
# 1. Install dependencies
sudo pacman -S --noconfirm hostapd dnsmasq iw

# 2. Create virtual AP interface
sudo iw phy phy0 interface add wlo1_ap type __ap
sudo ip link set dev wlo1_ap address 02:00:00:00:00:01
sudo ip link set wlo1_ap up
sudo ip addr add 192.168.10.1/24 dev wlo1_ap

# 3. Create hostapd config
cat << 'EOF' | sudo tee /etc/hostapd/hostapd-wlo1.conf
interface=wlo1_ap
driver=nl80211
ssid=KDX-Hotspot
hw_mode=g
channel=2
ieee80211n=1
wmm_enabled=1
auth_algs=1
wpa=2
wpa_passphrase=kdx12345
wpa_key_mgmt=WPA-PSK
wpa_pairwise=CCMP
rsn_pairwise=CCMP
EOF

# 4. Create dnsmasq config
cat << 'EOF' | sudo tee /etc/dnsmasq.d/wlo1_ap.conf
interface=wlo1_ap
dhcp-range=192.168.10.10,192.168.10.100,12h
dhcp-option=3,192.168.10.1
dhcp-option=6,192.168.10.1
server=8.8.8.8
server=8.8.4.4
log-queries
log-dhcp
EOF

# 5. Enable IP forwarding
echo "net.ipv4.ip_forward=1" | sudo tee /etc/sysctl.d/99-kdx-hotspot.conf
sudo sysctl -p /etc/sysctl.d/99-kdx-hotspot.conf

# 6. Set up NAT
sudo iptables -t nat -A POSTROUTING -o wlo1 -j MASQUERADE
sudo iptables -A FORWARD -i wlo1 -o wlo1_ap -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i wlo1_ap -o wlo1 -j ACCEPT

# 7. Start services
sudo systemctl enable --now kdx-hotspot.service
```

---

## 5. systemd Service Details

**Unit:** `/etc/systemd/system/kdx-hotspot.service`

```ini
[Unit]
Description=KDX WiFi Hotspot
After=network-online.target NetworkManager.service
Wants=network-online.target
PartOf=NetworkManager.service

[Service]
Type=forking
RemainAfterExit=yes
ExecStart=/usr/local/bin/kdx-hotspot-start.sh
ExecStop=/usr/local/bin/kdx-hotspot-stop.sh
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
```

**Start script:** `/usr/local/bin/kdx-hotspot-start.sh`
- Deletes any stale `wlo1_ap` interface
- Creates `wlo1_ap` as AP type
- Assigns MAC `02:00:00:00:00:01` and brings it up
- Assigns `192.168.10.1/24`
- Starts `hostapd -B` (daemonized)
- Starts `dnsmasq` with hotspot config
- Adds iptables NAT rules

**Stop script:** `/usr/local/bin/kdx-hotspot-stop.sh`
- Kills `hostapd` and `dnsmasq`
- Removes iptables rules
- Brings down and deletes `wlo1_ap`

---

## 6. Verify It’s Working

```bash
# Service status
sudo systemctl status kdx-hotspot

# AP info
sudo iw dev wlo1_ap info

# Active connections (kdx must stay connected)
nmcli connection show --active

# DHCP leases (when a client connects)
sudo cat /var/lib/misc/dnsmasq.leases

# NAT rules
sudo iptables -t nat -L POSTROUTING -v
```

---

## 7. Rollback / Restore to This Stable Point

To revert to this exact state on a fresh install or after breaking something:

### A. Remove hotspot completely
```bash
sudo systemctl disable --now kdx-hotspot
sudo rm /etc/systemd/system/kdx-hotspot.service
sudo rm /usr/local/bin/kdx-hotspot-start.sh
sudo rm /usr/local/bin/kdx-hotspot-stop.sh
sudo rm /etc/hostapd/hostapd-wlo1.conf
sudo rm /etc/dnsmasq.d/wlo1_ap.conf
sudo rm /etc/sysctl.d/99-kdx-hotspot.conf
sudo iptables -t nat -D POSTROUTING -o wlo1 -j MASQUERADE
sudo iptables -D FORWARD -i wlo1 -o wlo1_ap -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -D FORWARD -i wlo1_ap -o wlo1 -j ACCEPT
sudo iw dev wlo1_ap del 2>/dev/null || true
sudo pkill -9 hostapd || true
sudo pkill -9 dnsmasq || true
sudo sysctl -p
sudo systemctl daemon-reload
```

### B. Restore SDDM theme to KDX branding
```bash
sudo cp /home/kdx/kdx-full-backup-2026-07-25/themes/sddm-corners/theme.conf /usr/share/sddm/themes/Corners/theme.conf
sudo cp /home/kdx/Downloads/kdx_wallpaper.png /usr/share/sddm/themes/Corners/backgrounds/bg.png
```

### C. Restore Hyprland window rules (if corrupted)
```bash
# These are already in the active config, but backup is at:
cp /home/kdx/kdx-full-backup-2026-07-25/.config/hypr/windowrules.conf /home/kdx/.config/hypr/windowrules.conf
cp /home/kdx/kdx-full-backup-2026-07-25/.config/hypr/userprefs.conf /home/kdx/.config/hypr/userprefs.conf
hyprctl reload
```

---

## 8. Snapper / Timeshift Notes

This is a **configuration restore point**, not a full filesystem snapshot.

For Timeshift, mark this as a restore point label:
```
timeshift --create --comments "KDX-hotspot-stable-2026-07-26"
```

For snapper (if btrfs root is used):
```
sudo snapper -c root create --description "KDX hotspot stable point"
sudo snapper -c root create --description "pre-hotspot-build" --pre-number <previous>
```

Key directories to back up separately if not using Timeshift:
- `/etc/hostapd/`
- `/etc/dnsmasq.d/`
- `/etc/sysctl.d/`
- `/etc/systemd/system/kdx-hotspot.service`
- `/usr/local/bin/kdx-hotspot-*.sh`
- `/usr/share/sddm/themes/Corners/`
- `/home/kdx/.config/hypr/`
- `/home/kdx/.config/hypr/hyprlock/`

---

## 9. Troubleshooting

| Issue | Fix |
|-------|-----|
| `kdx` disconnects when hotspot starts | Ensure `wlo1_ap` is on same channel as `kdx` router (channel 2) |
| No internet on mobile | Check NAT rules: `sudo iptables -t nat -L POSTROUTING` |
| `wlo1_ap` won’t come up | Delete and recreate: `sudo iw dev wlo1_ap del && sudo iw phy phy0 interface add wlo1_ap type __ap` |
| hostapd fails to start | Check `/tmp/hostapd.log` or run `sudo hostapd -d /etc/hostapd/hostapd-wlo1.conf` |
| MAC conflict | Virtual AP already uses `02:00:00:00:00:01`; if still conflicting, change to another local MAC |
| Service won’t start | Check `sudo journalctl -xeu kdx-hotspot` |

---

## 10. Current Stable State Summary

As of 2026-07-26:
- `kdx` WiFi: connected, auto-reconnect enabled
- `KDX-Hotspot`: active via systemd service, enabled at boot
- SDDM: Corners theme with KDX red (`#FF0033`) branding
- Hyprland: window size rules in `windowrules.conf`, battery removed from lock screen
- No ad-hoc mode (unsupported by hardware)
