# Branding Guide

Official KnightDragonX brand assets and theming.

---

## Brand Assets

All assets are in the [`branding/`](https://github.com/KSitharanimsara/knightdragonx-os/tree/main/branding) folder:

| File | Purpose | Size |
|------|---------|------|
| `logo.png` | Primary logo (alt logo = main logo) | 667 KB |
| `wallpaper.png` | Desktop / lock-screen wallpaper | 256 KB |
| `brand-portfolio.html` | Official brand portfolio with demo clips | 1.7 MB |

---

## Brand Colors

| Name | Hex | Usage |
|------|-----|-------|
| **KDX Red** | `#FF0033` | Primary accent, borders, active states |
| **KDX Orange** | `#FFAA00` | Secondary accent, highlights |
| **Dark BG** | `#111111` | Backgrounds, panels |
| **Darker BG** | `#1e1d2f` | Input fields, cards |
| **White** | `#FFFFFF` | Text on dark backgrounds |

---

## Theme Integration

### SDDM Login Screen
- **Theme:** Corners (customized)
- **Config:** `/usr/share/sddm/themes/Corners/`
- **Background:** `branding/wallpaper.png`
- **Accent:** `#FF0033` (login button, session/power buttons)
- **Text:** White on dark

### Hyprland / Wayland
- **Active border:** `#FF0033` → `#FFAA00` gradient
- **Inactive border:** `#1e1d2f`
- **Rofi accent:** `#FF0033`
- **Waybar accent:** `#FF0033`

### GTK / Qt
- **Theme:** Wallbash-Gtk
- **Qt style:** Kvantum (wallbash.kvconfig)
- **Highlight color:** `#FF0033`

### Terminal (Kitty)
- **Cursor:** `#FF0033`
- **Active tab:** `#FF0033`
- **Selection:** `#FF0033`

---

## Applying Branding

### SDDM
```bash
sudo cp branding/wallpaper.png /usr/share/sddm/themes/Corners/backgrounds/bg.png
sudo cp -r configs/sddm/corners-theme /usr/share/sddm/themes/Corners
```

### Wallpaper
```bash
cp branding/wallpaper.png ~/Pictures/kdx_wallpaper.png
# Set via hyde-shell or hyprctl
```

### Rofi
```bash
cp configs/rofi/theme.rasi ~/.config/rofi/theme.rasi
```

---

## Brand Portfolio

The `brand-portfolio.html` file is the official KnightDragonX brand book. It includes:

- Logo usage guidelines
- Color palette specifications
- Typography standards
- Application mockups
- Demo clips / videos

Open it in a browser to view the full brand guidelines.

---

## Creating Custom Themes

Use the `KnightDragonX` theme in HyDE as a template:

```bash
cp -r ~/.config/hyde/themes/KnightDragonX ~/.config/hyde/themes/MyTheme
# Edit hypr.theme, kitty.theme, rofi.theme, waybar.theme
```

Key files to customize:
- `hypr.theme` — border colors, active/inactive
- `kitty.theme` — terminal colors
- `rofi.theme` — launcher colors
- `waybar.theme` — bar colors
- `kvantum/kvconfig.theme` — Qt app colors
