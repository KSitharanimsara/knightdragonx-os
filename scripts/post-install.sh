#!/bin/bash
set -euo pipefail

# KnightDragonX OS Post-Install Script
# Copies user configs and applies KDX theme settings

echo "========================================"
echo " KnightDragonX OS Post-Install"
echo "========================================"
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

# Check if running as regular user
if [[ $EUID -eq 0 ]]; then
   echo "This script must be run as a regular user, not root."
   exit 1
fi

echo "[1/6] Creating config directories..."
mkdir -p ~/.config/hypr
mkdir -p ~/.config/waybar
mkdir -p ~/.config/rofi
mkdir -p ~/.config/kitty
mkdir -p ~/.config/Kvantum
mkdir -p ~/.local/share/hyde
mkdir -p ~/.local/share/fonts

echo "[2/6] Copying Hyprland configs..."
cp -r "$REPO_DIR/configs/hyprland/"* ~/.config/hypr/ 2>/dev/null || true

echo "[3/6] Copying application configs..."
cp -r "$REPO_DIR/configs/waybar/"* ~/.config/waybar/ 2>/dev/null || true
cp -r "$REPO_DIR/configs/rofi/"* ~/.config/rofi/ 2>/dev/null || true
cp -r "$REPO_DIR/configs/kitty/"* ~/.config/kitty/ 2>/dev/null || true
cp -r "$REPO_DIR/configs/kvantum/"* ~/.config/Kvantum/ 2>/dev/null || true

echo "[4/6] Copying HyDE theme..."
cp -r "$REPO_DIR/configs/hyde/"* ~/.local/share/hyde/ 2>/dev/null || true

echo "[5/6] Copying shell configs..."
if [[ -f "$REPO_DIR/configs/system/zshrc" ]]; then
    cp "$REPO_DIR/configs/system/zshrc" ~/.zshrc
fi
if [[ -f "$REPO_DIR/configs/system/bashrc" ]]; then
    cp "$REPO_DIR/configs/system/bashrc" ~/.bashrc
fi

echo "[6/6] Applying KDX theme..."
if command -v hydectl &> /dev/null; then
    hydectl theme set KnightDragonX 2>/dev/null || true
    hydectl wm reload 2>/dev/null || true
fi

echo ""
echo "========================================"
echo " Post-install complete!"
echo "========================================"
echo ""
echo "Configs applied from: $REPO_DIR"
echo ""
echo "Next steps:"
echo "  - Reboot or run: Super + Shift + R"
echo "  - Verify theme: hydectl theme list"
echo "  - Start hotspot: sudo systemctl enable --now kdx-hotspot"
echo ""
