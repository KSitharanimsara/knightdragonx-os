#!/bin/bash
set -euo pipefail

# KnightDragonX OS Installer
# Installs base dependencies and applies KDX system configuration

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
echo " KnightDragonX OS Installer"
echo "========================================"
echo ""

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   error "This script must be run as root (use sudo)."
fi

# Detect OS
if ! command -v pacman &> /dev/null; then
    error "Error: This installer requires Arch Linux or an Arch-based distribution."
fi

# Create backup directory
BACKUP_DIR="/tmp/kdx-backup-$(date +%Y%m%d-%H%M%S)"
log "Creating backup directory: $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

log "[1/6] Updating system..."
if ! pacman -Syu --noconfirm; then
    error "System update failed. Please check your internet connection and try again."
fi

log "[2/6] Installing base dependencies..."
DEPENDENCIES=(
    git curl wget
    hyprland xdg-desktop-portal-hyprland
    sddm waybar rofi kitty
    kvantum qt5ct qt6ct
    dunst swaync
    pipewire wireplumber
    fastfetch hyde-shell
    zsh
)

if ! pacman -S --noconfirm --needed "${DEPENDENCIES[@]}"; then
    error "Failed to install dependencies. Please check the error messages above."
fi

log "[3/6] Detecting GPU..."
GPU=$(lspci -k -nn | grep -A 5 "VGA" | grep "in use" | head -1 || true)

if [[ -z "$GPU" ]]; then
    warn "Could not detect GPU. Will install mesa as fallback."
    warn "You may need to manually install GPU drivers after installation."
    pacman -S --noconfirm --needed mesa || warn "Failed to install mesa"
else
    if echo "$GPU" | grep -qi "nvidia"; then
        log "Detected NVIDIA GPU."
        read -p "Install NVIDIA drivers? (nvidia-dkms, nvidia-utils) [y/N]: " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            pacman -S --noconfirm --needed nvidia-dkms nvidia-utils || warn "Failed to install NVIDIA drivers"
        else
            log "Skipping NVIDIA driver installation"
        fi
    elif echo "$GPU" | grep -qi "amd"; then
        log "Detected AMD GPU. Installing mesa..."
        pacman -S --noconfirm --needed mesa xf86-video-amdgpu || warn "Failed to install AMD drivers"
    elif echo "$GPU" | grep -qi "intel"; then
        log "Detected Intel GPU. Installing mesa..."
        pacman -S --noconfirm --needed mesa intel-media-driver || warn "Failed to install Intel drivers"
    else
        warn "Unknown GPU type detected. Installing mesa as fallback..."
        pacman -S --noconfirm --needed mesa || warn "Failed to install mesa"
    fi
fi

log "[4/6] Enabling services..."
if ! systemctl enable NetworkManager; then
    warn "Failed to enable NetworkManager"
fi

if ! systemctl enable sddm; then
    warn "Failed to enable sddm"
fi

log "[5/6] Applying KDX SDDM theme..."
SDDM_THEME_DIR="/usr/share/sddm/themes/Corners"
SDDM_CONF_DIR="/etc/sddm.conf.d"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

if [[ -d "$REPO_DIR/configs/sddm/corners-theme" ]]; then
    log "Backing up existing SDDM theme..."
    if [[ -d "$SDDM_THEME_DIR" ]]; then
        cp -r "$SDDM_THEME_DIR" "$BACKUP_DIR/" 2>/dev/null || true
    fi
    
    log "Installing KDX SDDM theme..."
    cp -r "$REPO_DIR/configs/sddm/corners-theme" "$SDDM_THEME_DIR" || warn "Failed to copy SDDM theme"
else
    warn "SDDM theme directory not found in repository"
fi

if [[ -f "$REPO_DIR/configs/sddm/sddm.conf" ]]; then
    log "Applying SDDM configuration..."
    mkdir -p "$SDDM_CONF_DIR"
    cp "$REPO_DIR/configs/sddm/sddm.conf" "$SDDM_CONF_DIR/the_hyde_project.conf" || warn "Failed to copy SDDM config"
else
    warn "SDDM config file not found in repository"
fi

log "[6/6] Creating restore point..."
RESTORE_POINT="$BACKUP_DIR/install-info.txt"
cat > "$RESTORE_POINT" << EOF
KnightDragonX OS Installation
Date: $(date)
Backup Directory: $BACKUP_DIR

Installed Packages:
$(pacman -Q | grep -E "(hyprland|waybar|rofi|kitty|kvantum|sddm|dunst|swaync|pipewire|fastfetch|hyde-shell)" || echo "Package list unavailable")

GPU Driver Status:
$GPU

Notes:
- SDDM theme installed to: $SDDM_THEME_DIR
- SDDM config installed to: $SDDM_CONF_DIR
EOF

echo ""
echo "========================================"
echo -e " ${GREEN}Installation complete!${NC}"
echo "========================================"
echo ""
echo "Next steps:"
echo "  1. Run ./scripts/post-install.sh as your regular user"
echo "  2. Reboot your system"
echo "  3. Select KnightDragonX theme in HyDE"
echo ""
echo "Backup location: $BACKUP_DIR"
echo ""

