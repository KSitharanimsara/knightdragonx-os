#!/bin/bash
set -euo pipefail

# KnightDragonX OS Post-Install Script
# Copies user configs and applies KDX theme settings

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

echo "========================================"
echo " KnightDragonX OS Post-Install"
echo "========================================"
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

# Check if running as regular user
if [[ $EUID -eq 0 ]]; then
   error "This script must be run as a regular user, not root."
fi

# Create backup directory
BACKUP_DIR="/tmp/kdx-post-backup-$(date +%Y%m%d-%H%M%S)"
log "Creating backup directory: $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

log "[1/7] Creating config directories..."
CONFIG_DIRS=(
    ~/.config/hypr
    ~/.config/waybar
    ~/.config/rofi
    ~/.config/kitty
    ~/.config/Kvantum
    ~/.local/share/hyde
    ~/.local/share/fonts
)

for dir in "${CONFIG_DIRS[@]}"; do
    mkdir -p "$dir" || warn "Failed to create directory: $dir"
done

log "[2/7] Backing up existing configs..."
EXISTING_CONFIGS=(
    ".config/hypr"
    ".config/waybar"
    ".config/rofi"
    ".config/kitty"
    ".config/Kvantum"
)

for config in "${EXISTING_CONFIGS[@]}"; do
    if [[ -d "$HOME/$config" ]] && [[ "$(ls -A "$HOME/$config" 2>/dev/null)" ]]; then
        log "Backing up $config..."
        cp -r "$HOME/$config" "$BACKUP_DIR/" 2>/dev/null || warn "Failed to backup $config"
    fi
done

log "[3/7] Copying Hyprland configs..."
if [[ -d "$REPO_DIR/configs/hyprland" ]]; then
    cp -r "$REPO_DIR/configs/hyprland/"* ~/.config/hypr/ 2>/dev/null || warn "Failed to copy Hyprland configs"
else
    warn "Hyprland configs directory not found in repository"
fi

log "[4/7] Copying application configs..."
APP_CONFIGS=(
    "waybar:~/.config/waybar"
    "rofi:~/.config/rofi"
    "kitty:~/.config/kitty"
    "kvantum:~/.config/Kvantum"
)

for item in "${APP_CONFIGS[@]}"; do
    IFS=':' read -r src dst <<< "$item"
    src_dir="$REPO_DIR/configs/$src"
    if [[ -d "$src_dir" ]]; then
        cp -r "$src_dir/"* "${dst/#\~/$HOME}/" 2>/dev/null || warn "Failed to copy $src configs"
    else
        warn "$src configs directory not found"
    fi
done

log "[5/7] Copying HyDE theme..."
if [[ -d "$REPO_DIR/configs/hyde" ]]; then
    cp -r "$REPO_DIR/configs/hyde/"* ~/.local/share/hyde/ 2>/dev/null || warn "Failed to copy HyDE theme"
else
    warn "HyDE theme directory not found in repository"
fi

log "[6/7] Copying shell configs..."
if [[ -f "$REPO_DIR/configs/system/zshrc" ]]; then
    if [[ -f ~/.zshrc ]]; then
        log "Backing up existing .zshrc..."
        cp ~/.zshrc "$BACKUP_DIR/zshrc.backup" || warn "Failed to backup .zshrc"
    fi
    cp "$REPO_DIR/configs/system/zshrc" ~/.zshrc || warn "Failed to copy zshrc"
else
    warn "zshrc file not found in repository"
fi

if [[ -f "$REPO_DIR/configs/system/bashrc" ]]; then
    if [[ -f ~/.bashrc ]]; then
        log "Backing up existing .bashrc..."
        cp ~/.bashrc "$BACKUP_DIR/bashrc.backup" || warn "Failed to backup .bashrc"
    fi
    cp "$REPO_DIR/configs/system/bashrc" ~/.bashrc || warn "Failed to copy bashrc"
else
    warn "bashrc file not found in repository"
fi

log "[7/7] Applying KDX theme..."
if command -v hydectl &> /dev/null; then
    log "Setting KnightDragonX theme..."
    if hydectl theme set KnightDragonX 2>/dev/null; then
        log "Theme applied successfully!"
    else
        warn "Failed to apply theme. You can set it manually later."
    fi
    
    log "Reloading window manager..."
    if hydectl wm reload 2>/dev/null; then
        log "WM reloaded successfully!"
    else
        warn "Failed to reload WM. You may need to restart manually."
    fi
else
    warn "hydectl not found. Please ensure Hyde is installed correctly."
    warn "You can apply the theme manually from HyDE settings."
fi

# Save installation info
INSTALL_INFO="$BACKUP_DIR/post-install-info.txt"
cat > "$INSTALL_INFO" << EOF
KnightDragonX OS Post-Installation
Date: $(date)
User: $(whoami)
Backup Directory: $BACKUP_DIR

Configs Applied:
- Hyprland: ~/.config/hypr
- Waybar: ~/.config/waybar
- Rofi: ~/.config/rofi
- Kitty: ~/.config/kitty
- Kvantum: ~/.config/Kvantum
- HyDE Theme: ~/.local/share/hyde
- Shell configs: ~/.zshrc, ~/.bashrc

Notes:
- Backup of previous configs saved to: $BACKUP_DIR
- To restore previous configs, copy files from backup directory
EOF

echo ""
echo "========================================"
echo -e " ${GREEN}Post-install complete!${NC}"
echo "========================================"
echo ""
echo "Configs applied from: $REPO_DIR"
echo "Backup location: $BACKUP_DIR"
echo ""
echo "Next steps:"
echo "  - Reboot or run: Super + Shift + R"
echo "  - Verify theme: hydectl theme list"
echo "  - Check logs: journalctl -b | grep -i hypr"
echo ""
echo "Troubleshooting:"
echo "  - If you experience issues, check the wiki at:"
echo "    https://github.com/The-Hyde-Project/KnightDragonX-OS/wiki"
echo ""

