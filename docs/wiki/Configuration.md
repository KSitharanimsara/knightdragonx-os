# Configuration

Detailed configuration reference for KnightDragonX OS components.

---

## Hyprland

Main config: `~/.config/hypr/hyprland.conf`  
User prefs: `~/.config/hypr/userprefs.conf`  
Window rules: `~/.config/hypr/windowrules.conf`

### Key Settings

| Setting | Value | Purpose |
|---------|-------|---------|
| `general:gaps_in` | `5` | Inner window gaps |
| `general:gaps_out` | `10` | Outer window gaps |
| `general:border_size` | `2` | Window border width |
| `decoration:rounding` | `8` | Corner radius |
| `decoration:blur` | `true` | Enable blur |
| `input:touchpad:natural_scroll` | `no` | Normal scroll direction |

### Animations

Located in `~/.config/hypr/animations/`  
Active: `animations.conf` → `theme.conf`

Available presets:
- `classic.conf`
- `diablo-1.conf`, `diablo-2.conf`
- `dynamic.conf`
- `fast.conf`
- `high.conf`
- `minimal-1.conf`, `minimal-2.conf`
- `optimized.conf`
- `standard.conf`

### Window Rules

Located in `~/.config/hypr/windowrules.conf`

Key rules:
- Opacity for terminals, browsers, editors
- Float rules for dialogs, image viewers
- Size rules for common apps
- No initial focus for JetBrains dropdowns

---

## Waybar

Config: `~/.config/waybar/config.jsonc`  
Style: `~/.config/waybar/style.css`  
Theme: `~/.config/waybar/theme.css`

### Modules

- Workspaces
- Window title
- CPU / RAM / GPU
- Network
- Bluetooth
- Volume / Brightness
- Battery
- Clock
- Custom buttons (logout, restart, etc.)

---

## Rofi

Config: `~/.config/rofi/theme.rasi`

### Modes
- Application launcher (`Super + A`)
- Window switcher (`Super + Tab`)
- File finder (`Super + Shift + E`)
- Clipboard (`Super + V`)

### Theme
- Accent: `#FF0033`
- Font: Cantarell
- Corner radius: 8px

---

## Kitty Terminal

Config: `~/.config/kitty/kitty.conf`  
Theme: `~/.config/kitty/theme.conf`

### Key Settings
```ini
font_family JetBrainsMono Nerd Font
font_size 12
window_padding_width 8
window_padding_height 8
background_opacity 0.95
dynamic_background_opacity yes
```

---

## Kvantum (Qt Theme)

Config: `~/.config/Kvantum/wallbash/wallbash.kvconfig`

### Key Colors
- Highlight: `#FF0033`
- Link: `#FF0033`
- Border: `#FF0033`
- Active text: `#FF0033`

---

## HyDE Shell

Config: `~/.local/share/hyde/config-registry.toml`  
Env: `~/.local/share/hyde/env-theme`

### Features
- Theme switching
- Wallpaper management
- Wallbash dynamic theming
- Rofi launchers
- Keybinding hints

---

## Shell

### Zsh
Config: `~/.zshrc`

Plugins:
- `zsh-autosuggestions`
- `zsh-syntax-highlighting`
- `zsh-completions`

### Bash
Config: `~/.bashrc`

---

## Environment Variables

Set in `~/.zshenv`:
```bash
export GTK_THEME=Wallbash-Gtk
export COLOR_SCHEME=prefer-dark
export QT_QPA_PLATFORMTHEME=qt5ct
export QT_STYLE_OVERRIDE=kvantum
```

---

## NVIDIA (If Applicable)

Config: `~/.config/hypr/nvidia.conf`

Key settings:
```ini
env = LIBVA_DRIVER_NAME,nvidia
env = GBM_BACKEND,nvidia-drm
env = __GLX_VENDOR_LIBRARY_NAME,nvidia
```

Power management: `kdx-nvidia-power.service`  
Uses `nvidia-settings PowerMizer` (not `nvidia-smi -pl`)
