# KnightDragonX OS Brand Portfolio

This directory contains the official brand assets and portfolio template for KnightDragonX OS.

## Files

- **brand-portfolio.html** — Interactive brand guidelines and asset showcase
- **logo.png** — Primary logo asset
- **wallpaper.png** — Hero wallpaper (4K)

## Usage

### Viewing the Portfolio

Open `brand-portfolio.html` in any modern web browser:

```bash
# Using a local server (recommended)
python3 -m http.server 8000 --directory branding

# Then visit: http://localhost:8000/brand-portfolio.html
```

Or simply open the file directly in your browser.

## Brand Assets Included

### Logo Pack
- PNG format with transparency
- SVG vector version (in source)
- Icon variants for Waybar/system tray
- Grid construction guide

### Color Palette
- **Obsidian Black** `#000000` — Primary background
- **Neon Red** `#FF0033` — Active states, accents, glow effects
- **Pure White** `#FFFFFF` — Text, logos on dark
- **Dark Gray** `#111111`, `#222222` — Secondary surfaces

### Typography
- **Inter** — UI text, headings (Weights: 300, 400, 500, 600, 700, 900)
- **JetBrains Mono Nerd** — Terminal, Waybar, code (Weights: 400, 500, 700)

### Iconography
- Waybar glyphs (16px grid, 1.5px stroke)
- Low-poly line style
- Neon red active state with glow

### Wallpapers
- Hero variant (3840×2160)
- Lockscreen variant
- Minimal circuit variant

## Design Principles

1. **Obsidian Depth** — Always use pure black for backgrounds
2. **Neon Life** — Red only for active/focus states (max 8% of surface)
3. **Precision Grid** — Every element aligned to modular grid
4. **Glow Intentionally** — All red elements must have blur/glow
5. **No Bloat** — Clean, minimal, purposeful design

## Hyprland Integration

```ini
# general {
    gaps_in = 6
    gaps_out = 12
    border_size = 2
    col.active_border = rgba(FF0033FF)
    rounding = 16
# }
```

## License

Personal + OS Use • Attribution Required

© 2026 KnightDragonX OS — Made in Moratuwa, LK
