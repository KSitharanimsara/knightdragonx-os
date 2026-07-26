# Branding Guide

Official KnightDragonX brand assets and theming.

---

## Brand Assets

All assets are in the [`branding/`](https://github.com/KSitharanimsara/knightdragonx-os/tree/main/branding) folder:

| File | Purpose | Size |
|------|---------|------|
| `logo.png` | Primary logo (alt logo = main logo) | 667 KB |
| `wallpaper.png` | Desktop / lock-screen wallpaper | 256 KB |
| `brand-portfolio.html` | **Interactive brand portfolio** with color palette, typography, icons, and download links | ~50 KB |

---

## Brand Portfolio

The [`brand-portfolio.html`](https://github.com/KSitharanimsara/knightdragonx-os/blob/main/branding/brand-portfolio.html) file is the **official interactive KnightDragonX brand book**. Open it in any modern browser to view:

### Features
- **🎨 Color Palette** — Click-to-copy hex codes with usage rules
- **📝 Typography** — Inter (UI) and JetBrains Mono (code) showcase
- **🔷 Iconography** — Waybar glyph examples with neon glow effects
- **💾 Downloads** — Direct links to logo, wallpaper, and theme packs
- **📱 Responsive** — Works on mobile, tablet, and desktop
- **⚡ Interactive** — Smooth scroll navigation, hover effects, toast notifications

### Sections
1. **Overview** — Hero section with brand introduction
2. **Colors** — Obsidian Neon system with copy-to-clipboard functionality
3. **Typography** — Font samples for UI and code
4. **Icons** — Waybar system glyphs
5. **Downloads** — Asset packs with version info and checksums

### Usage
```bash
# Open locally
xdg-open branding/brand-portfolio.html

# Or host on GitHub Pages
# Visit: https://KSitharanimsara.github.io/knightdragonx-os/branding/brand-portfolio.html
```

---

## Brand Colors

| Name | Hex | Usage |
|------|-----|-------|
| **KDX Red** | `#FF0033` | Primary accent, borders, active states, glow effects |
| **KDX Orange** | `#FFAA00` | Secondary accent, highlights |
| **Dark BG** | `#111111` | Backgrounds, panels |
| **Darker BG** | `#0A0A0A` | Cards, depth layers |
| **White** | `#FFFFFF` | Text on dark backgrounds |
| **Gray** | `#888888` | Secondary text, labels |

**Usage Rules:**
- **Black #000000** — always background. Never use dark gray as page bg.
- **Neon Red** — only for active, focus, glow, cursor, workspace. Max 8% of surface.
- **White** — text, logo on dark. 92% opacity for body to reduce harshness.

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

---

## Design Philosophy

**Obsidian Neon** — A precision-crafted design system for modern Linux desktops:

- **Minimal Surface** — Black backgrounds dominate, red accents guide attention
- **Functional Beauty** — Every element serves a purpose in the WM environment
- **Performance First** — Lightweight CSS, no heavy frameworks
- **Accessibility** — High contrast ratios, clear visual hierarchy
- **Consistency** — Same colors across SDDM, Hyprland, Waybar, GTK, Qt

---

## Resources

- [GitHub Repository](https://github.com/KSitharanimsara/knightdragonx-os)
- [Installation Guide](Installation.md)
- [Configuration Guide](Configuration.md)
- [Troubleshooting](Troubleshooting.md)
