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
