# Troubleshooting

Common issues and their fixes for KnightDragonX OS.

---

## Hyprland

### Black screen on boot
```bash
# Check GPU drivers
lspci -k -nn | grep -A 5 "VGA"
# AMD/Intel: sudo pacman -S mesa
# NVIDIA: sudo pacman -S nvidia-dkms
```

### Config won’t reload
```bash
# Check syntax
hyprctl reload
# If errors, validate configs are in correct files
# Window rules belong in windowrules.conf, not userprefs.conf
```

### Window size too large
Window size rules are in `~/.config/hypr/windowrules.conf`.  
To add new app sizes, edit that file and reload.

---

## WiFi / Hotspot

### Hotspot won’t start
```bash
# Check service status
sudo systemctl status kdx-hotspot

# Check logs
sudo journalctl -xeu kdx-hotspot

# Common fixes
sudo iw dev wlo1_ap del
sudo systemctl restart kdx-hotspot
```

### `wlo1_ap` interface missing
```bash
# Recreate virtual AP
sudo iw dev wlo1_ap del 2>/dev/null || true
sudo iw phy phy0 interface add wlo1_ap type __ap
sudo ip link set dev wlo1_ap address 02:00:00:00:00:01
sudo ip link set wlo1_ap up
```

### No internet on mobile
```bash
# Verify NAT rules
sudo iptables -t nat -L POSTROUTING -v

# Verify kdx WiFi is connected
nmcli connection show --active

# Restart hotspot
sudo systemctl restart kdx-hotspot
```

### MAC address conflict
Virtual AP uses `02:00:00:00:00:01`.  
If still conflicting, edit `kdx-hotspot-start.sh` and change the MAC.

---

## SDDM

### Theme not applying
```bash
# Check config
cat /etc/sddm.conf.d/the_hyde_project.conf

# Verify theme exists
ls /usr/share/sddm/themes/Corners/

# Restart SDDM
sudo systemctl restart sddm
```

### Logo not showing
```bash
# Verify logo exists
ls -la /usr/share/sddm/themes/Corners/kdx_logo.jpg

# Check Main.qml references correct filename
grep -r "kdx_logo" /usr/share/sddm/themes/Corners/
```

---

## Audio

### No sound
```bash
# Check pipewire
systemctl --user status pipewire pipewire-pulse wireplumber

# Restart
systemctl --user restart pipewire pipewire-pulse wireplumber
```

### Bluetooth blocked
```bash
# Unblock
rfkill unblock bluetooth

# Start service
sudo systemctl enable --now bluetooth
```

---

## Display

### Wrong resolution / scaling
```bash
# Check monitors config
cat ~/.config/hypr/monitors.conf

# List displays
hyprctl monitors
```

### Screen tearing
```bash
# Enable vsync in hyprland.conf
# For NVIDIA: ensure nvidia.conf is loaded
```

---

## Performance

### High CPU usage
```bash
# Check animations
cat ~/.config/hypr/animations.conf

# Try lighter preset
cp ~/.config/hypr/animations/minimal-1.conf ~/.config/hypr/animations.conf
hyprctl reload
```

### Gaming mode
```bash
# Toggle with Super + Alt + G
# Or manually:
hyprctl reload ~/.config/hypr/workflows/gaming.conf
```

---

## Backup / Restore

### Configs corrupted
```bash
# Restore from repo
git clone https://github.com/KSitharanimsara/knightdragonx-os.git
cd knightdragonx-os
cp -r configs/* ~/.config/
cp -r configs/hyde/* ~/.local/share/hyde/
hyprctl reload
```

### Full system restore
Boot from Arch ISO and restore Timeshift/Snapper snapshot.

---

## Getting Help

- **GitHub Issues:** https://github.com/KSitharanimsara/knightdragonx-os/issues
- **Wiki:** https://github.com/KSitharanimsara/knightdragonx-os/wiki
- **Arch Wiki:** https://wiki.archlinux.org
- **Hyprland Wiki:** https://wiki.hypr.land
