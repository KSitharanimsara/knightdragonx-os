# KnightDragonX OS
<div align="center">

  <img src="branding/logo.png" alt="KnightDragonX Logo" width="180"/>

  **Arch-based · Hyprland · HyDE · KDX Branding**

  [![License](https://img.shields.io/badge/license-GPL--3.0-blue.svg)](LICENSE)
  [![Arch](https://img.shields.io/badge/Arch-Linux-1793D1?logo=archlinux&logoColor=white)](https://archlinux.org)
  [![Hyprland](https://img.shields.io/badge/Hyprland-0.56+-41B1E2?logo=hyprland&logoColor=white)](https://hyprland.org)
  [![SDDM](https://img.shields.io/badge/SDDM-Corners-FF0033?logo=linux&logoColor=white)](https://github.com/sddm/sddm)

</div>

---

## Overview

KnightDragonX OS is an Arch-based distribution / dotfiles suite focused on the **KnightDragonX** brand identity. It ships with:

- **Hyprland** compositor + **HyDE** tooling
- **SDDM** login manager with KDX Corners theme
- **KDX Hotspot** WiFi repeater service (AP + NAT)
- **Waybar**, **Rofi**, **Kitty**, **Kvantum** theming
- **KDE red** (`#FF0033`) accent palette
- **Timeshift / Snapper** restore-point workflow

> **Note:** This repo is a configuration + branding source. It is not a full ISO build system. For a complete installable image, see `docs/ARCH-INSTALL-GUIDE.txt`.

---

## Quick Start

```bash
# Clone
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

# Install hotspot service (optional)
sudo cp scripts/hotspot/* /etc/hostapd/ /etc/dnsmasq.d/ /etc/sysctl.d/ /etc/systemd/system/ /usr/local/bin/
sudo systemctl enable --now kdx-hotspot

# Apply SDDM theme (optional)
sudo cp -r configs/sddm/corners-theme /usr/share/sddm/themes/Corners
sudo cp configs/sddm/sddm.conf /etc/sddm.conf.d/the_hyde_project.conf
```

Then reload Hyprland:
```
Super + Shift + R
```

---

## Repository Structure

```
knightdragonx-os/
├── branding/              # Logos, wallpapers, brand portfolio
├── configs/
│   ├── hyprland/          # Hyprland, hyprlock, hypridle, animations, shaders
│   ├── waybar/            # Waybar config + styles
│   ├── rofi/              # Rofi theme
│   ├── kitty/             # Kitty terminal theme
│   ├── kvantum/           # Kvantum Qt theme
│   ├── hyde/              # HyDE shell + themes
│   ├── sddm/              # SDDM Corners theme + config
│   └── system/            # Shell, GTK, fastfetch, fish
├── scripts/
│   └── hotspot/           # WiFi hotspot systemd service + configs
├── restore-points/        # Backup + hotspot build guide
├── docs/                  # Install guide, wiki source
└── .github/               # Issue templates, workflows
```

---

## Branding

The official KnightDragonX brand assets live in `branding/`:

| File | Purpose |
|------|---------|
| `logo.png` | Primary logo (alt logo = main logo) |
| `wallpaper.png` | Desktop / lock-screen wallpaper |
| `brand-portfolio.html` | Official brand portfolio with demo clips |

Brand colors:
- **Primary:** `#FF0033` (KDE red)
- **Accent:** `#FFAA00`
- **Background:** `#111111` / `#1e1d2f`

---

## Hotspot (WiFi Repeater)

See `restore-points/HOTSPOT-GUIDE.md` for the full build log and restore steps.

Quick summary:
- **SSID:** `KDX-Hotspot`
- **Password:** `kdx12345`
- **Client subnet:** `192.168.10.0/24`
- **Internet:** shared from the primary `kdx` WiFi connection
- **Service:** `kdx-hotspot.service` (enabled at boot)

---

## Backup / Restore

### Timeshift
```bash
sudo timeshift --create --comments "KDX-stable-2026-07-26"
```

### Snapper (btrfs)
```bash
sudo snapper -c root create --description "KDX hotspot stable point"
```

### Manual backup checklist
See `restore-points/` for exact file lists.

---

## System Requirements

- **OS:** Arch Linux (or Arch-based)
- **Kernel:** 6.12+ recommended
- **Compositor:** Hyprland 0.56+
- **WiFi:** Any adapter supporting AP + managed concurrent mode
  - Tested: Realtek RTL8852BE (`rtw89_8852bte`)
- **RAM:** 4 GB minimum, 8 GB recommended
- **Disk:** 30 GB minimum for base + configs

---

## Troubleshooting

| Issue | Fix |
|-------|-----|
| Hotspot won’t start | Check `sudo journalctl -xeu kdx-hotspot` |
| `wlo1_ap` missing | `sudo iw dev wlo1_ap del && sudo iw phy phy0 interface add wlo1_ap type __ap` |
| No internet on mobile | Verify NAT: `sudo iptables -t nat -L POSTROUTING` |
| SDDM theme not applying | Check `/etc/sddm.conf.d/the_hyde_project.conf` |
| Hyprland reload errors | Validate `userprefs.conf` — window rules belong in `windowrules.conf` |

---

## License

GPL-3.0. See `LICENSE` for details.

---

<div align="center">

**KnightDragonX OS** · Arch + Hyprland + KDX Branding

</div>
