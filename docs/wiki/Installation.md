# Installation Guide

This guide covers installing Arch Linux and setting up the KnightDragonX OS configuration.

---

## Prerequisites

- UEFI system recommended
- 30 GB+ free disk space
- Internet connection (wired or mobile hotspot)
- Arch Linux ISO

---

## 1. Base Arch Install

Follow the official [Arch Installation Guide](https://wiki.archlinux.org/title/Installation_guide).

Key steps:
```bash
# Update system clock
timedatectl set-ntp true

# Partition disk (example for UEFI + ext4)
fdisk /dev/nvme0n1
# /dev/nvme0n1p1 - 512M EFI
# /dev/nvme0n1p2 - rest root

# Format
mkfs.fat -F32 /dev/nvme0n1p1
mkfs.ext4 /dev/nvme0n1p2

# Mount
mount /dev/nvme0n1p2 /mnt
mkdir -p /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot

# Install base system
pacstrap /mnt base linux linux-firmware base-devel

# Generate fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Chroot
arch-chroot /mnt
```

---

## 2. Essential Packages

```bash
pacman -S --noconfirm \
  git vim nano networkmanager \
  hyprland xdg-desktop-portal-hyprland \
  sddm waybar rofi kitty \
  kvantum qt5ct qt6ct \
  dunst swaync \
  pipewire wireplumber \
  fastfetch hyde-shell
```

---

## 3. KDX Configuration

```bash
# Clone the repo
git clone https://github.com/KSitharanimsara/knightdragonx-os.git
cd knightdragonx-os

# Copy configs
cp -r configs/hyprland/* ~/.config/hypr/
cp -r configs/waybar/* ~/.config/waybar/
cp -r configs/rofi/* ~/.config/rofi/
cp -r configs/kitty/* ~/.config/kitty/
cp -r configs/kvantum/* ~/.config/Kvantum/
cp -r configs/hyde/* ~/.local/share/hyde/
cp configs/system/zshrc ~/.zshrc
cp configs/system/bashrc ~/.bashrc

# Apply SDDM theme
sudo cp -r configs/sddm/corners-theme /usr/share/sddm/themes/Corners
sudo cp configs/sddm/sddm.conf /etc/sddm.conf.d/the_hyde_project.conf

# Enable services
sudo systemctl enable NetworkManager
sudo systemctl enable sddm
```

---

## 4. Hotspot Service (Optional)

```bash
sudo cp scripts/hotspot/* /etc/hostapd/ /etc/dnsmasq.d/ /etc/sysctl.d/ /etc/systemd/system/ /usr/local/bin/
sudo systemctl enable --now kdx-hotspot
```

---

## 5. Reboot

```bash
exit  # leave chroot
umount -R /mnt
reboot
```

---

## Post-Install

- Log in via SDDM
- Press `Super + Shift + R` to reload Hyprland
- Connect to your WiFi network
- Enable hotspot: `sudo systemctl start kdx-hotspot`

---

## Troubleshooting

| Issue | Fix |
|-------|-----|
| No WiFi | Install `networkmanager` and `iwd`, enable `NetworkManager.service` |
| Black screen | Check GPU drivers: `sudo pacman -S mesa` (AMD/Intel) or `nvidia-dkms` (NVIDIA) |
| SDDM theme not loading | Verify `/etc/sddm.conf.d/the_hyde_project.conf` exists |
| Hotspot fails | Check `sudo journalctl -xeu kdx-hotspot` |
