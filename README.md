# KnightDragonX OS

<div align="center">

  <img src="branding/logo.png" alt="KnightDragonX Logo" width="200" style="filter: drop-shadow(0 4px 20px rgba(255,0,51,0.3));"/>

  **Arch-based · Hyprland 0.56+ · HyDE · KDX Branding · Wallbash**

  [![License](https://img.shields.io/badge/license-GPL--3.0-blue.svg)](LICENSE)
  [![Arch Linux](https://img.shields.io/badge/Arch-Linux-1793D1?logo=archlinux&logoColor=white)](https://archlinux.org)
  [![Hyprland](https://img.shields.io/badge/Hyprland-0.56%2B-41B1E2?logo=hyprland&logoColor=white)](https://hyprland.org)
  [![SDDM](https://img.shields.io/badge/SDDM-Corners-FF0033?logo=linux&logoColor=white)](https://github.com/sddm/sddm)
  [![HyDE](https://img.shields.io/badge/HyDE-Shell-FFAA00?logo=github&logoColor=white)](https://github.com/HyDE-Project/HyDE)
  [![Wallbash](https://img.shields.io/badge/Wallbash-Dynamic-888888)](https://github.com/HyDE-Project/HyDE/wiki/Wallbash)

</div>

---

## Overview

KnightDragonX OS is an Arch-based Linux distribution focused on the **KnightDragonX** brand identity. It ships with a complete theming stack featuring KDE red (`#FF0033`) and orange (`#FFAA00`) accent colors.

### What's Included

- **Hyprland** compositor + **HyDE** tooling with one-click theme switching
- **SDDM Corners** login manager with KDX branding
- **Wallbash** dynamic theming based on wallpaper
- **Waybar**, **Rofi**, **Kitty**, **Kvantum** with KDX styling
- **Tela-circle-dracula** icon theme
- **Timeshift / Snapper** restore-point workflow
- **fastfetch** with KDX logo

> **Note:** This repo is a configuration + branding source. It is not a full ISO build system. For a complete installable image, see `docs/ARCH-INSTALL-GUIDE.txt`.

---

## Theme System

The KnightDragonX theme is a complete HyDE theme with:

| Component | Description |
|-----------|-------------|
| `hypr.theme` | Hyprland borders, blur, shadows, Wallbash integration |
| `hyprlock.theme` | Lock screen with dynamic Wallbash colors |
| `kitty.theme` | Terminal colors with KDX accents |
| `rofi.theme` | Application launcher styling |
| `waybar.theme` | Status bar with KDX branding |
| `kvantum/kvantum.theme` | Qt widget styling with SVG |
| `wallbash.svg` | Dynamic theme generation |
| `wallpapers/` | 7+ KDX branded wallpapers |

### Brand Colors

| Name | Hex | Usage |
|------|-----|-------|
| **KDX Red** | `#FF0033` | Active borders, selection, highlights |
| **KDX Orange** | `#FFAA00` | Secondary accent, minutes display |
| **Obsidian** | `#111111` | Backgrounds, panels |
| **Dark BG 2** | `#1e1d2f` | Secondary backgrounds |
| **White** | `#FFFFFF` | Text on dark backgrounds |
| **Muted** | `#888888` | Secondary text |

---

## Quick Start

### Automated Install

```bash
git clone https://github.com/KSitharanimsara/knightdragonx-os.git
cd knightdragonx-os

# System packages + GPU drivers + services (root)
sudo ./scripts/installer.sh

# User configs + theme (user)
./scripts/post-install.sh

# Reboot
sudo reboot
```

### Manual Install

```bash
# Clone repository
git clone https://github.com/KSitharanimsara/knightdragonx-os.git
cd knightdragonx-os

# Restore user configs
cp -r configs/hyprland/* ~/.config/hypr/
cp -r configs/waybar/* ~/.config/waybar/
cp -r configs/rofi/* ~/.config/rofi/
cp -r configs/kitty/* ~/.config/kitty/
cp -r configs/kvantum/* ~/.config/Kvantum/
cp -r configs/hyde/* ~/.local/share/hyde/
cp configs/system/zshrc ~/.zshrc
cp configs/system/bashrc ~/.bashrc
cp configs/system/zshenv ~/.zshenv

# Apply SDDM theme (optional)
sudo cp -r configs/sddm/corners-theme /usr/share/sddm/themes/Corners
sudo cp configs/sddm/sddm.conf /etc/sddm.conf.d/the_hyde_project.conf
```

Then reload Hyprland: `Super + Shift + R`

---

## Repository Structure

```
knightdragonx-os/
├── branding/              # Logos, wallpapers, brand portfolio
├── configs/
│   ├── hyprland/          # Hyprland, hyprlock, hypridle, animations, shaders
│   ├── waybar/            # Waybar config + styles
│   ├── rofi/              # Rofi theme + assets
│   ├── kitty/             # Kitty terminal theme
│   ├── kvantum/           # Kvantum Qt theme
│   ├── hyde/              # HyDE shell + themes
│   ├── sddm/              # SDDM Corners theme + config
│   └── system/            # Shell, GTK, fastfetch, fish configs
├── scripts/
│   ├── installer.sh          # System installer (root): GPU drivers, services, SDDM
│   └── post-install.sh       # User setup: configs, theme, shell
├── restore-points/        # Backup guide
├── docs/                  # Install guide, wiki source
└── .github/               # Issue templates, workflows
```

---

## Installation Guide

For complete Arch Linux installation instructions:

1. **Pre-Installation** - Boot ISO, verify UEFI, identify GPU, connect to internet
2. **Partition & Format** - Create GPT partitions (512MB EFI + root)
3. **Install Base System** - pacstrap with GPU drivers (CRITICAL: NVIDIA before reboot)
4. **System Configuration** - Timezone, locale, hostname, GRUB, user creation
5. **SDDM & Services** - Configure SDDM, enable NetworkManager and sddm
6. **Post-Install** - Install KDX configs, apply SDDM theme
7. **Verification** - Check all components are working

See [docs/wiki/Installation.md](docs/wiki/Installation.md) for the full guide.

---

## WiFi Hotspot

> **Note:** The KDX Hotspot service has been removed. The Realtek rtw89 driver does not support reliable AP mode on this hardware while maintaining a primary WiFi connection. Internet access must remain on the primary `kdx` network.

---

## Backup / Restore

### Timeshift
```bash
sudo timeshift --create --comments "KDX-stable-2026-07-26"
```

### Snapper (btrfs)
```bash
sudo snapper -c root create --description "KDX stable point"
```

### Manual backup
See `restore-points/` for exact file lists and restore procedures.

---

## System Requirements

| Requirement | Minimum | Recommended |
|-------------|---------|-------------|
| **OS** | Arch Linux (or Arch-based) | Arch Linux latest |
| **GPU** | AMD / Intel / NVIDIA | Latest drivers |
| **RAM** | 4 GB | 8 GB |
| **Storage** | 30 GB | 60 GB+ |
| **WiFi** | AP + managed concurrent mode | RTL8852BE tested |
| **Boot** | 64-bit x86_64 | UEFI |

---

## FAQ

### How do I switch themes?
Use `hydectl theme set <theme-name>` to switch. List available themes with `hydectl theme list`.

### What if I get a black screen?
Switch to TTY with Ctrl+Alt+F2, check logs with `journalctl -b -p err`. Refer to [docs/wiki/Black-Screen-Fix.md](docs/wiki/Black-Screen-Fix.md).

### How do I customize colors?
Wallbash extracts colors from your wallpaper automatically. Edit `wallbash.svg` and run `wal -i <wallpaper>` to regenerate.

### Is it suitable for gaming?
Yes! Includes gaming workflow with optimized settings, Steam/Proton/Wine support, and controller integration. Toggle with Super+Alt+G.

---

## Documentation

| Document | Description |
|----------|-------------|
| [Installation](docs/wiki/Installation.md) | Complete Arch install with KDX setup |
| [Black Screen Fix](docs/wiki/Black-Screen-Fix.md) | GPU-specific troubleshooting |
| [Branding](docs/wiki/Branding.md) | Colors, logos, theme integration |
| [Configuration](docs/wiki/Configuration.md) | Hyprland, Waybar, Rofi, Kitty |
| [Restore Points](docs/wiki/Restore-Points.md) | Backup and recovery |
| [Troubleshooting](docs/wiki/Troubleshooting.md) | Common issues and fixes |

---

## License

GPL-3.0. See [LICENSE](LICENSE) for details.

---

<div align="center">

**KnightDragonX OS** · Arch + Hyprland + KDX Branding · Stable: 2026-07-26

</div>