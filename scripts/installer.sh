#!/bin/bash
set -euo pipefail

# KnightDragonX OS Installer
# Installs base dependencies and applies KDX system configuration

echo "========================================"
echo " KnightDragonX OS Installer"
echo "========================================"
echo ""

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root (use sudo)." 
   exit 1
fi

# Detect OS
if ! command -v pacman &> /dev/null; then
    echo "Error: This installer requires Arch Linux or an Arch-based distribution."
    exit 1
fi

echo "[1/5] Updating system..."
pacman -Syu --noconfirm

echo "[2/5] Installing base dependencies..."
pacman -S --noconfirm --needed \
    git curl wget \
    hyprland xdg-desktop-portal-hyprland \
    sddm waybar rofi kitty \
    kvantum qt5ct qt6ct \
    dunst swaync \
    pipewire wireplumber \
    fastfetch hyde-shell \
    zsh

echo "[3/5] Installing GPU drivers..."
GPU=$(lspci -k -nn | grep -A 5 "VGA" | grep "in use" | head -1 || true)
if echo "$GPU" | grep -qi "nvidia"; then
    echo "Detected NVIDIA GPU. Installing nvidia-dkms..."
    pacman -S --noconfirm --needed nvidia-dkms nvidia-utils
elif echo "$GPU" | grep -qi "amd"; then
    echo "Detected AMD GPU. Installing mesa..."
    pacman -S --noconfirm --needed mesa xf86-video-amdgpu
elif echo "$GPU" | grep -qi "intel"; then
    echo "Detected Intel GPU. Installing mesa..."
    pacman -S --noconfirm --needed mesa intel-media-driver
else
    echo "Could not detect GPU. Installing mesa as fallback..."
    pacman -S --noconfirm --needed mesa
fi

echo "[4/5] Enabling services..."
systemctl enable NetworkManager
systemctl enable sddm

echo "[5/5] Applying KDX SDDM theme..."
SDDM_THEME_DIR="/usr/share/sddm/themes/Corners"
SDDM_CONF_DIR="/etc/sddm.conf.d"

if [[ -d "$(dirname "$0")/../configs/sddm/corners-theme" ]]; then
    cp -r "$(dirname "$0")/../configs/sddm/corners-theme" "$SDDM_THEME_DIR"
fi

if [[ -f "$(dirname "$0")/../configs/sddm/sddm.conf" ]]; then
    mkdir -p "$SDDM_CONF_DIR"
    cp "$(dirname "$0")/../configs/sddm/sddm.conf" "$SDDM_CONF_DIR/the_hyde_project.conf"
fi

echo ""
echo "========================================"
echo " Installation complete!"
echo "========================================"
echo ""
echo "Next steps:"
echo "  1. Run ./scripts/post-install.sh as your regular user"
echo "  2. Reboot your system"
echo "  3. Select KnightDragonX theme in HyDE"
echo ""
