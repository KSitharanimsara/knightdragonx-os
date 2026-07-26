# Welcome to KnightDragonX OS Wiki

**Arch-based · Hyprland · HyDE · KDX Branding · Wallbash**

---

## Quick Links

| Page | Description |
|------|-------------|
| [Installation](Installation) | Complete step-by-step Arch install with GPU setup |
| [Black Screen Fix](Black-Screen-Fix) | Diagnose and fix black screen issues (NVIDIA/AMD/Intel) |
| [Hotspot Setup](Hotspot-Setup) | WiFi repeater / AP + NAT bridge |
| [Branding](Branding) | Logos, colors, SDDM theme, Wallbash |
| [Configuration](Configuration) | Hyprland, Waybar, Rofi, Kitty, Kvantum |
| [Restore Points](Restore-Points) | Timeshift / Snapper backup guide |
| [Troubleshooting](Troubleshooting) | Common issues and fixes |
| [Automated Installer](Automated-Installer) | One-command installer and post-install scripts |
| [Automated Installer](Automated-Installer) | One-command installer and post-install scripts |

---

## What is KnightDragonX OS?

KnightDragonX OS is an **Arch-based Linux distribution** focused on the KnightDragonX brand identity. It combines:

- **Hyprland** compositor with **HyDE** tooling and one-click theme switching
- **SDDM Corners** login manager with custom KDX branding
- **KDX Hotspot** WiFi repeater service (AP + NAT bridge)
- **Wallbash** dynamic theming based on wallpaper colors
- **KDE red** (`#FF0033`) accent palette throughout every component
- **Tela-circle-dracula** icon theme for a consistent circular look
- **Timeshift / Snapper** restore-point workflow for instant rollback
- **fastfetch** with KDX logo for system info display

---

## Stable Point

**Date:** 2026-07-26  
**Kernel:** Linux 6.12.x  
**Hyprland:** 0.56+  
**HyDE:** Latest  
**WiFi Adapter:** Realtek RTL8852BE (`rtw89_8852bte`)  
**GPU Support:** NVIDIA (dkms) / AMD (mesa) / Intel (mesa)

---

## Repository

- **GitHub:** https://github.com/KSitharanimsara/knightdragonx-os
- **GitHub Pages:** https://KSitharanimsara.github.io/knightdragonx-os
- **License:** GPL-3.0

---

## Theme System

The KnightDragonX theme is a complete HyDE theme:

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

## Getting Started

### Quick Install

```bash
# Clone repository
git clone https://github.com/KSitharanimsara/knightdragonx-os.git
cd knightdragonx-os

# Run automated installer
chmod +x scripts/installer.sh scripts/post-install.sh
sudo ./scripts/installer.sh
./scripts/post-install.sh
```

### Manual Install

```bash
# Copy configs
cp -r configs/hyprland/* ~/.config/hypr/
cp -r configs/waybar/* ~/.config/waybar/
cp -r configs/rofi/* ~/.config/rofi/
cp -r configs/kitty/* ~/.config/kitty/
cp -r configs/kvantum/* ~/.config/Kvantum/
cp -r configs/hyde/* ~/.local/share/hyde/
cp configs/system/zshrc ~/.zshrc

# Apply SDDM theme
sudo cp -r configs/sddm/corners-theme /usr/share/sddm/themes/Corners
sudo cp configs/sddm/sddm.conf /etc/sddm.conf.d/the_hyde_project.conf

# Reload Hyprland
Super + Shift + R
```

---

## Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| Super + Q | Open terminal (Kitty) |
| Super + A | Open application launcher (Rofi) |
| Super + Tab | Window switcher |
| Super + Shift + Q | Close focused window |
| Super + Shift + R | Reload Hyprland config |
| Super + L | Lock screen (Hyprlock) |
| Super + Shift + E | Open file manager (Dolphin) |
| Super + V | Open clipboard manager |
| Super + Space | Toggle floating / tiling |
| Super + 1-9 | Switch workspace |
| Super + Shift + 1-9 | Move window to workspace |
| Super + Alt + G | Toggle gaming workflow |

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

## Troubleshooting

| Issue | Fix |
|-------|-----|
| Hotspot won't start | Check `sudo journalctl -xeu kdx-hotspot` |
| `wlo1_ap` missing | `sudo iw dev wlo1_ap del && sudo iw phy phy0 interface add wlo1_ap type __ap` |
| No internet on mobile | Verify NAT: `sudo iptables -t nat -L POSTROUTING` |
| SDDM theme not applying | Check `/etc/sddm.conf.d/the_hyde_project.conf` |
| Hyprland reload errors | Validate `userprefs.conf` — window rules belong in `windowrules.conf` |
| Black screen after install | Switch to TTY: Ctrl+Alt+F2, check logs with `journalctl -b -p err` |

---

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

---

<div align="center">

**KnightDragonX OS** · Arch + Hyprland + KDX Branding · Stable: 2026-07-26

</div>
