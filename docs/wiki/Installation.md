# Installation Guide

This guide covers installing Arch Linux and setting up the KnightDragonX OS configuration.

---

## Prerequisites

- UEFI system recommended
- 30 GB+ free disk space
- Internet connection (wired or mobile hotspot)
- Arch Linux ISO (latest from https://archlinux.org/download/)

---

## Phase 1: Pre-Installation

### 1.1 Boot the Arch ISO

1. Create a bootable USB with `dd` or `balenaEtcher`
2. Boot from USB, select **Arch Linux install medium**
3. Verify you're in UEFI mode:
   ```bash
   ls /sys/firmware/efi/efivars
   ```
   If this directory exists, you're in UEFI mode. If not, reboot and enable UEFI in BIOS.

### 1.2 Identify Your GPU (Critical)

**This step prevents black screen issues later.**

```bash
lspci -k -nn | grep -A 5 "VGA"
```

| GPU Vendor | Driver Package | Notes |
|------------|---------------|-------|
| AMD | `mesa` `xf86-video-amdgpu` | Usually works out of the box |
| Intel | `mesa` `intel-media-driver` | Usually works out of the box |
| NVIDIA | `nvidia-dkms` `nvidia-utils` | Needs kernel parameters, see Section 1.4 |

### 1.3 Network Connection

```bash
# Check interfaces
ip link

# Connect to WiFi (if no ethernet)
iwctl
[iwd]# device list
[iwd]# station wlo1 scan
[iwd]# station wlo1 get-networks
[iwd]# station wlo1 connect YOUR_SSID
[iwd]# exit

# Test connection
ping archlinux.org
```

### 1.4 NVIDIA Pre-Boot Configuration (If Applicable)

**Before proceeding, if you have NVIDIA:**

1. At the GRUB boot menu, press `e` to edit boot parameters
2. Add to the `linux` line:
   ```
   module_blacklist=nouveau nvidia_drm.modeset=1
   ```
3. Press `F10` or `Ctrl+X` to boot

This prevents the open-source `nouveau` driver from loading and enables DRM for NVIDIA.

---

## Phase 2: Base Arch Installation

### 2.1 System Clock & Keymap

```bash
timedatectl set-ntp true

# Set keyboard layout if needed
loadkeys us
```

### 2.2 Partition Disk

**Example for UEFI + ext4 on `/dev/nvme0n1`:**

```bash
fdisk /dev/nvme0n1
```

Inside `fdisk`:
```
g          # GPT partition table
n          # new partition
1          # partition 1
            # default first sector
+512M      # 512 MB EFI
t          # change type
1          # EFI System
n
2          # partition 2
            # default first sector
            # default last sector (rest of disk)
t
2          # change type to Linux filesystem
w          # write changes
```

### 2.3 Format Partitions

```bash
mkfs.fat -F32 /dev/nvme0n1p1
mkfs.ext4 /dev/nvme0n1p2
```

### 2.4 Mount Partitions

```bash
mount /dev/nvme0n1p2 /mnt
mkdir -p /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot
```

### 2.5 Install Base System

```bash
# Core system
pacstrap /mnt base linux linux-firmware base-devel

# GPU drivers (install BEFORE rebooting)
# For NVIDIA:
pacstrap /mnt nvidia-dkms nvidia-utils
# For AMD (usually preinstalled):
# pacstrap /mnt mesa xf86-video-amdgpu
# For Intel:
# pacstrap /mnt mesa intel-media-driver

# Essential tools
pacstrap /mnt \
  git vim nano networkmanager \
  hyprland xdg-desktop-portal-hyprland \
  sddm waybar rofi kitty \
  kvantum qt5ct qt6ct \
  dunst swaync \
  pipewire wireplumber \
  fastfetch hyde-shell \
  efibootmgr grub os-prober
```

### 2.6 Generate fstab

```bash
genfstab -U /mnt >> /mnt/etc/fstab
# Verify:
cat /mnt/etc/fstab
```

### 2.7 Chroot

```bash
arch-chroot /mnt
```

---

## Phase 3: System Configuration

### 3.1 Time Zone & Clock

```bash
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
hwclock --systohc
```

### 3.2 Localization

```bash
# /etc/locale.gen — uncomment:
# en_US.UTF-8 UTF-8

locale-gen

# /etc/locale.conf
echo "LANG=en_US.UTF-8" > /etc/locale.conf
```

### 3.3 Hostname & Network

```bash
echo "knightdragonx" > /etc/hostname

# /etc/hosts
cat > /etc/hosts << 'EOF'
127.0.0.1   localhost
::1         localhost
127.0.1.1   knightdragonx.localdomain knightdragonx
EOF
```

### 3.4 Bootloader (GRUB)

```bash
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB

# For NVIDIA: add kernel parameters
mkdir -p /etc/default
cat > /etc/default/grub << 'EOF'
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash module_blacklist=nouveau nvidia_drm.modeset=1"
GRUB_DEFAULT=0
GRUB_TIMEOUT=5
EOF

grub-mkconfig -o /boot/grub/grub.cfg
```

### 3.5 Initramfs

```bash
mkinitcpio -P
```

### 3.6 Root Password

```bash
passwd
```

### 3.7 Create User

```bash
useradd -m -G wheel,audio,video,optical,storage -s /bin/zsh kdx
passwd kdx

# Sudo privileges
EDITOR=vim visudo
# Uncomment: %wheel ALL=(ALL:ALL) ALL
```

### 3.8 Enable Essential Services

```bash
systemctl enable NetworkManager
systemctl enable sddm
```

### 3.9 SDDM Configuration

```bash
mkdir -p /etc/sddm.conf.d
cat > /etc/sddm.conf.d/the_hyde_project.conf << 'EOF'
[Autologin]
Relogin=false
Session=
User=

[General]
HaltCommand=/usr/bin/systemctl poweroff
RebootCommand=/usr/bin/systemctl reboot
DisplayServer=wayland

[Theme]
Current=Corners

[Users]
MaximumUid=60513
MinimumUid=1000
EOF
```

### 3.10 Exit Chroot & Reboot

```bash
exit
umount -R /mnt
reboot
```

---

## Phase 4: First Boot & GPU Verification

### 4.1 Boot into System

1. Remove USB
2. Boot into your new Arch install
3. Log in via SDDM as user `kdx`

### 4.2 Verify GPU Drivers

```bash
# Check which driver is loaded
lspci -k -nn | grep -A 5 "VGA"

# Expected output:
# AMD: Kernel driver in use: amdgpu
# Intel: Kernel driver in use: i915
# NVIDIA: Kernel driver in use: nvidia
```

### 4.3 If Black Screen Occurs

**Do not panic.** Follow the [Black Screen Fix Guide](restore-points/BLACKSCREEN-FIX.md).

Quick checks:
```bash
# 1. Switch to TTY: Ctrl+Alt+F2
# 2. Check logs:
journalctl -b -p err --no-pager | tail -50
# 3. Test Hyprland manually:
export XDG_RUNTIME_DIR=/run/user/$(id -u)
exec Hyprland
```

---

## Phase 5: KDX Configuration

### 5.1 Clone Repository

```bash
git clone https://github.com/KSitharanimsara/knightdragonx-os.git
cd knightdragonx-os
```

### 5.2 Copy User Configs

```bash
# Hyprland
cp -r configs/hyprland/* ~/.config/hypr/

# Waybar
cp -r configs/waybar/* ~/.config/waybar/

# Rofi
cp -r configs/rofi/* ~/.config/rofi/

# Kitty
cp -r configs/kitty/* ~/.config/kitty/

# Kvantum (Qt theme)
cp -r configs/kvantum/* ~/.config/Kvantum/

# HyDE shell
cp -r configs/hyde/* ~/.local/share/hyde/

# Shell configs
cp configs/system/zshrc ~/.zshrc
cp configs/system/bashrc ~/.bashrc
```

### 5.3 Apply SDDM Theme

```bash
sudo cp -r configs/sddm/corners-theme /usr/share/sddm/themes/Corners
sudo cp configs/sddm/sddm.conf /etc/sddm.conf.d/the_hyde_project.conf
```

### 5.4 Reload Desktop

```bash
Super + Shift + R
```

Or from terminal:
```bash
hyprctl reload
```

---

## Phase 6: Hotspot Service (Optional)

```bash
sudo cp scripts/hotspot/* /etc/hostapd/ /etc/dnsmasq.d/ /etc/sysctl.d/ /etc/systemd/system/ /usr/local/bin/
sudo systemctl enable --now kdx-hotspot
```

Verify:
```bash
sudo systemctl status kdx-hotspot
sudo iw dev wlo1_ap info
```

---

## Phase 7: Post-Install

- Connect to WiFi: `nmtui` or click network applet
- Set wallpaper: use HyDE theme switcher or `hyprctl`
- Check audio: `pavucontrol` or `amixer`
- Enable bluetooth: `sudo systemctl enable --now bluetooth`
- Test gaming: `Super + Alt + G` to toggle gaming workflow
- Create restore point: `sudo timeshift --create --comments "KDX-base-install"`

---

## Verification Checklist

- [ ] System boots to SDDM login screen
- [ ] Login succeeds and Hyprland starts
- [ ] WiFi connected (`nmcli connection show --active`)
- [ ] Audio works (`pactl info` or `pavucontrol`)
- [ ] Bluetooth works (if applicable)
- [ ] SDDM shows KDX branding (red accents, wallpaper)
- [ ] Rofi launcher works (`Super + A`)
- [ ] Terminal opens (`Super + Q`)
- [ ] Hotspot works (optional): `sudo systemctl start kdx-hotspot`
- [ ] No black screen on reboot

---

## Troubleshooting

| Issue | Fix |
|-------|-----|
| **Black screen after boot** | See [Black Screen Fix Guide](restore-points/BLACKSCREEN-FIX.md) |
| No WiFi | `sudo systemctl enable --now NetworkManager`, `nmtui` |
| No audio | `systemctl --user enable --now pipewire pipewire-pulse wireplumber` |
| SDDM theme not loading | Verify `/etc/sddm.conf.d/the_hyde_project.conf` |
| Hotspot fails | Check `sudo journalctl -xeu kdx-hotspot` |
| Touchpad issues | Check `~/.config/hypr/userprefs.conf` touchpad settings |
| Apps look wrong | Ensure GTK_THEME and QT_STYLE_OVERRIDE are set in `~/.zshenv` |

---

## Need Help?

- **Repository:** https://github.com/KSitharanimsara/knightdragonx-os
- **Wiki:** https://github.com/KSitharanimsara/knightdragonx-os/wiki
- **Issues:** https://github.com/KSitharanimsara/knightdragonx-os/issues
- **Black Screen Guide:** See `restore-points/BLACKSCREEN-FIX.md`
