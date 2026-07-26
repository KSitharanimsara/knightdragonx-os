# Automated Installer

KnightDragonX OS includes two automated scripts to streamline installation:

- `scripts/installer.sh` — System packages, GPU drivers, services (run as root)
- `scripts/post-install.sh` — User configs, theme application (run as regular user)

---

## Quick Start

```bash
# Clone the repository
git clone https://github.com/KSitharanimsara/knightdragonx-os.git
cd knightdragonx-os

# Run installer (root)
sudo ./scripts/installer.sh

# Run post-install (user)
./scripts/post-install.sh

# Reboot
sudo reboot
```

---

## installer.sh

Runs as **root**. Performs:

1. **System update** — `pacman -Syu`
2. **Base dependencies** — Hyprland, SDDM, Waybar, Rofi, Kitty, Kvantum, PipeWire, HyDE, etc.
3. **GPU driver detection** — Installs `nvidia-dkms`, `mesa + amdgpu`, or `mesa + intel-media-driver` automatically
4. **Service enablement** — NetworkManager, SDDM
5. **SDDM theme** — Copies Corners theme and config

### Supported GPUs

| Vendor | Package |
|--------|---------|
| NVIDIA | `nvidia-dkms nvidia-utils` |
| AMD | `mesa xf86-video-amdgpu` |
| Intel | `mesa intel-media-driver` |

---

## post-install.sh

Runs as **regular user**. Performs:

1. **Creates config directories** — `~/.config/hypr/`, `~/.config/waybar/`, etc.
2. **Copies configs** — Hyprland, Waybar, Rofi, Kitty, Kvantum, HyDE
3. **Copies shell configs** — `.zshrc`, `.bashrc`
4. **Applies theme** — Sets KnightDragonX as active HyDE theme

---

## Manual Fallback

If the scripts fail, apply configs manually:

```bash
# User configs
cp -r configs/hyprland/* ~/.config/hypr/
cp -r configs/waybar/* ~/.config/waybar/
cp -r configs/rofi/* ~/.config/rofi/
cp -r configs/kitty/* ~/.config/kitty/
cp -r configs/kvantum/* ~/.config/Kvantum/
cp -r configs/hyde/* ~/.local/share/hyde/
cp configs/system/zshrc ~/.zshrc

# System configs (root)
sudo cp -r configs/sddm/corners-theme /usr/share/sddm/themes/Corners
sudo cp configs/sddm/sddm.conf /etc/sddm.conf.d/the_hyde_project.conf
```

---

## Troubleshooting

| Issue | Fix |
|-------|-----|
| Script fails at GPU detection | Manually install drivers: `sudo pacman -S nvidia-dkms` or `sudo pacman -S mesa xf86-video-amdgpu` |
| Configs not copying | Ensure you cloned the full repo: `git clone --depth=1 https://github.com/KSitharanimsara/knightdragonx-os.git` |
| Theme not applying | Run `hydectl theme list` then `hydectl theme set KnightDragonX` |
| SDDM theme missing | Verify `/usr/share/sddm/themes/Corners/` exists and `/etc/sddm.conf.d/the_hyde_project.conf` sets `Current=Corners` |

---

## Repository Structure

```
knightdragonx-os/
├── scripts/
│   ├── installer.sh          # System-level installer (root)
│   └── post-install.sh       # User-level setup (user)
├── configs/
│   ├── hyprland/             # Hyprland, hyprlock, hypridle
│   ├── waybar/               # Waybar config + styles
│   ├── rofi/                 # Rofi theme + assets
│   ├── kitty/                # Kitty terminal theme
│   ├── kvantum/              # Kvantum Qt theme
│   ├── hyde/                 # HyDE shell + themes
│   ├── sddm/                 # SDDM Corners theme + config
│   └── system/               # Shell configs
└── docs/wiki/
    ├── Installation.md
    ├── Black-Screen-Fix.md
    ├── Hotspot-Setup.md
    ├── Branding.md
    ├── Configuration.md
    ├── Restore-Points.md
    └── Troubleshooting.md
```
