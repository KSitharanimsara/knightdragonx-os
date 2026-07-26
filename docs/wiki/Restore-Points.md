# Restore Points

Backup and restore guide for KnightDragonX OS.

---

## Snapshot Tools

### Timeshift (Recommended)

```bash
# Install
sudo pacman -S --noconfirm timeshift

# Create restore point
sudo timeshift --create --comments "KDX-stable-2026-07-26"

# List snapshots
sudo timeshift --list

# Restore
sudo timeshift --restore
```

### Snapper (btrfs)

```bash
# Install
sudo pacman -S --noconfirm snapper

# Create config
sudo snapper -c root create --description "KDX stable point"

# List snapshots
sudo snapper -c root list

# Restore
sudo snapper -c root undochange 42..43
```

---

## What to Back Up

### System Configs
```bash
# SDDM theme
sudo cp -r /usr/share/sddm/themes/Corners /backup/
sudo cp /etc/sddm.conf.d/the_hyde_project.conf /backup/
```

### User Configs
```bash
# Hyprland
cp -r ~/.config/hypr ~/backup/
cp -r ~/.config/waybar ~/backup/
cp -r ~/.config/rofi ~/backup/
cp -r ~/.config/kitty ~/backup/
cp -r ~/.config/Kvantum ~/backup/

# HyDE
cp -r ~/.local/share/hyde ~/backup/

# Shell
cp ~/.zshrc ~/backup/
cp ~/.bashrc ~/backup/
cp ~/.zshenv ~/backup/
```

### Branding
```bash
cp branding/logo.png ~/backup/
cp branding/wallpaper.png ~/backup/
```

---

## Restore from Backup

```bash
# User configs
cp -r ~/backup/hypr/* ~/.config/hypr/
cp -r ~/backup/waybar/* ~/.config/waybar/
cp -r ~/backup/rofi/* ~/.config/rofi/

# Reload
hyprctl reload
```

---

## Stable Point Checklist

Use this checklist when creating a new restore point:

- [ ] `kdx` WiFi connected and auto-reconnect enabled
- [ ] SDDM Corners theme with KDX branding applied
- [ ] Hyprland configs validated (`hyprctl reload` clean)
- [ ] Wallpaper set to `kdx_wallpaper.png`
- [ ] Rofi theme using KDX red (`#FF0033`)
- [ ] Waybar theme matches KDX palette
- [ ] Battery removed from hyprlock
- [ ] Window size rules in `windowrules.conf`
- [ ] Timeshift/Snapper snapshot created

---

## Emergency Recovery

If the system won’t boot:

1. Boot from Arch ISO
2. Mount root partition
3. Mount EFI partition
4. Chroot:
   ```bash
   arch-chroot /mnt
   ```
5. Restore from Timeshift:
   ```bash
   timeshift --restore
   ```
6. Or manually restore configs from backup drive
