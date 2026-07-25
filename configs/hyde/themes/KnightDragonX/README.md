# KnightDragonX Theme

<div align="center">
  <img src="https://raw.githubusercontent.com/KSitharanimsara/knightdragonx-os/main/branding/logo.png" alt="KnightDragonX Logo" width="180"/>
</div>

**Arch-based · Hyprland · HyDE · KDX Branding**

---

## About

KnightDragonX is a dark theme for [HyDE](https://github.com/HyDE-Project/HyDE) featuring the official KnightDragonX brand identity with KDE red (`#FF0033`) and orange (`#FFAA00`) accents on an obsidian background.

## Screenshots

<div align="center">
  <img src="https://raw.githubusercontent.com/KSitharanimsara/knightdragonx-os/main/branding/wallpaper.png" alt="KDX Wallpaper" width="600"/>
  <p><i>Official KnightDragonX desktop background</i></p>
</div>

## Installation

```sh
hydectl theme import --name "KnightDragonX" --url https://github.com/KSitharanimsara/knightdragonx-os
```

Or manually:
```sh
cp -r Configs/.config/hyde/themes/KnightDragonX ~/.config/hyde/themes/
```

## Theme Components

| Component | Description |
|-----------|-------------|
| `hypr.theme` | Hyprland borders, blur, shadows, GTK/icon/cursor integration |
| `hyprlock.theme` | Lock screen with Wallbash dynamic colors |
| `kitty.theme` | Terminal colors with KDX red accents |
| `rofi.theme` | Application launcher styling |
| `waybar.theme` | Status bar colors |
| `kvantum/kvantum.theme` | Qt widget styling |
| `kvantum/kvconfig.theme` | Kvantum configuration |
| `animations.theme` | Window animations and bezier curves |
| `wallpapers/` | KDX branded wallpapers |

## Brand Colors

| Name | Hex | Usage |
|------|-----|-------|
| **KDX Red** | `#FF0033` | Active borders, selection, highlights |
| **KDX Orange** | `#FFAA00` | Secondary accent, minutes display |
| **Obsidian** | `#111111` | Backgrounds, panels |
| **White** | `#FFFFFF` | Text on dark backgrounds |

## Features

- **Wallbash Dynamic Theming** — Lock screen colors adapt to wallpaper
- **GTK/Icon/Cursor Integration** — Automatic system-wide theme application
- **KDX Branding** — Official red/orange accent palette
- **SDDM Corners Theme** — Matching login screen
- **Rounded Corners** — 16px window rounding
- **Blur & Shadows** — Subtle blur and KDX-tinted shadows

## Requirements

- [HyDE](https://github.com/HyDE-Project/HyDE) installed
- Hyprland 0.56+
- Kitty terminal
- Rofi
- Waybar
- Kvantum (for Qt theming)

## License

GPL-3.0 — see [LICENSE](../LICENSE)

---

<div align="center">
  <p>KnightDragonX OS · Arch + Hyprland + KDX Branding</p>
</div>
