# Black Screen Fix

Complete guide to diagnosing and fixing black screen issues on KnightDragonX OS.

---

## Quick Diagnosis

### 1. Check which display server is active
```bash
echo $XDG_SESSION_TYPE
```
Expected: `wayland` for Hyprland. If `x11`, SDDM may be forcing X11.

### 2. Check if Hyprland is running
```bash
hyprctl info
```
If it hangs or returns nothing, Hyprland likely crashed or never started.

### 3. Check GPU driver status
```bash
lspci -k -nn | grep -A 5 "VGA"
```
Look for `Kernel driver in use:` — this should show `amdgpu`, `i915`, or `nvidia`.

### 4. Check logs
```bash
# Hyprland logs
journalctl -b -u Hyprland --no-pager | tail -50

# GPU/driver logs
journalctl -b --no-pager | grep -i -E "gpu|drm|amdgpu|i915|nvidia|error|fail" | tail -30

# Display manager logs
sudo journalctl -b -u sddm --no-pager | tail -30
```

---

## Common Fixes

### A. SDDM forcing X11 (most common)

**Problem:** SDDM is configured with `DisplayServer=X11`, which conflicts with Wayland/Hyprland theming and can cause black screens.

**Fix:**
```bash
sudo mkdir -p /etc/sddm.conf.d
sudo tee /etc/sddm.conf.d/the_hyde_project.conf << 'EOF'
[Autologin]
Relogin=false
Session=
User=

[General]
HaltCommand=/usr/bin/systemctl poweroff
RebootCommand=/usr/bin/systemctl reboot
DisplayServer=wayland

[Theme]
Current=Corners

[Users]
MaximumUid=60513
MinimumUid=1000
EOF

sudo systemctl restart sddm
```

> **Note:** If `DisplayServer=wayland` causes issues with the SDDM Corners theme, set `DisplayServer=x11` and apply the SDDM theme fixes instead. Some SDDM themes have partial Wayland support.

### B. NVIDIA GPU black screen

**Problem:** NVIDIA GPUs often need explicit DRM kernel parameters and specific Hyprland config.

**Fix 1 — Add kernel parameters:**

Edit `/etc/default/grub`:
```bash
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash module_blacklist=nouveau nvidia_drm.modeset=1"
```

Then:
```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo mkinitcpio -P
```

**Fix 2 — NVIDIA Hyprland config:**

Ensure `~/.config/hypr/nvidia.conf` exists:
```ini
env = LIBVA_DRIVER_NAME,nvidia
env = GBM_BACKEND,nvidia-drm
env = __GLX_VENDOR_LIBRARY_NAME,nvidia
```

And in `hyprland.conf`:
```ini
source = ~/.config/hypr/nvidia.conf
```

### C. AMD GPU black screen

**Problem:** AMD GPUs may need firmware or kernel mode setting enabled.

**Fix:**
```bash
# Ensure firmware is installed
sudo pacman -S --noconfirm linux-firmware mesa

# Add kernel parameter if needed
sudo tee /etc/default/grub << 'EOF'
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash amdgpu.dc=0"
EOF
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo mkinitcpio -P
```

### D. Intel GPU black screen

**Problem:** Intel iGPU may need specific kernel parameters or firmware.

**Fix:**
```bash
sudo pacman -S --noconfirm linux-firmware mesa intel-media-driver

# Add to /etc/default/grub if using older Intel:
# GRUB_CMDLINE_LINUX_DEFAULT="quiet splash i915.enable_psr=0"
```

### E. Hyprland config syntax error

**Problem:** A typo in `hyprland.conf` or `userprefs.conf` can crash Hyprland silently.

**Fix:**
```bash
# Check config syntax by reloading
hyprctl reload

# If that hangs, switch to TTY (Ctrl+Alt+F2) and check:
hyprctl reload 2>&1

# Common issues:
# - windowrule placed in userprefs.conf instead of windowrules.conf
# - Missing closing brace }
# - Invalid monitor syntax
```

### F. Monitor / display output issue

**Problem:** External monitor connected but laptop screen black, or wrong output selected.

**Fix:**
```bash
# List monitors
hyprctl monitors

# Check monitors.conf
cat ~/.config/hypr/monitors.conf

# Example fix: force laptop screen as primary
# In monitors.conf:
# monitor = eDP-1, 1920x1080@60, 0x0, 1
# monitor = HDMI-A-1, 1920x1080@60, 1920x0, 1
```

### G. Missing or corrupted GPU firmware

**Problem:** `/lib/firmware/` missing GPU firmware blobs.

**Fix:**
```bash
# Reinstall firmware package
sudo pacman -S --noconfirm linux-firmware

# Check if firmware is present
ls /lib/firmware/amdgpu/ 2>/dev/null
ls /lib/firmware/i915/ 2>/dev/null
ls /lib/nvidia/ 2>/dev/null
```

### H. ACPI / kernel panic black screen

**Problem:** Kernel panics early, screen goes black before boot loader or after.

**Fix:**
```bash
# Add to kernel parameters:
# acpi=off (last resort, disables power management)
# nomodeset (uses fallback VESA driver)
# nouveau.modeset=0 (disables NVIDIA open-source driver)

# Edit /etc/default/grub, add to GRUB_CMDLINE_LINUX_DEFAULT, then:
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

---

## Recovery Steps

### Step 1: Switch to TTY

Press `Ctrl+Alt+F2` (or `F3` through `F6`). If you get a login prompt, the system is running and this is a display issue.

### Step 2: Check logs

```bash
journalctl -b -p err --no-pager | tail -50
```

### Step 3: Test Hyprland manually

```bash
# From TTY, after logging in as your user:
export XDG_RUNTIME_DIR=/run/user/$(id -u)
export WLR_NO_HARDWARE_CURSORS=1
exec Hyprland
```

If Hyprland starts in TTY but not via SDDM, the issue is with SDDM or the display manager session.

### Step 4: Test with minimal config

```bash
mv ~/.config/hypr/hyprland.conf ~/.config/hypr/hyprland.conf.bak
mv ~/.config/hypr/windowrules.conf ~/.config/hypr/windowrules.conf.bak
# Create minimal test config:
cat > ~/.config/hypr/hyprland.conf << 'EOF'
monitor = *, 1920x1080@60, 0x0, 1
exec = kitty
bind = SUPER, Q, exec, kitty
bind = SUPER, A, exec, rofi -show drun
bind = SUPER SHIFT, Q, killactive
EOF
hyprctl reload
```

### Step 5: Reinstall GPU drivers

```bash
# AMD
sudo pacman -S --noconfirm mesa xf86-video-amdgpu

# Intel
sudo pacman -S --noconfirm mesa xf86-video-intel

# NVIDIA
sudo pacman -S --noconfirm nvidia-dkms nvidia-utils
sudo mkinitcpio -P
```

### Step 6: Fallback to X11

If Wayland/Hyprland is incompatible with your hardware:

```bash
# Install X11 alternatives
sudo pacman -S --noconfirm xorg-server xorg-xinit xfce4

# Create ~/.xinitrc:
cat > ~/.xinitrc << 'EOF'
exec startxfce4
EOF

# Start X11:
startx
```

---

## Pre-Boot Checklist (Before Installing KDX)

To avoid black screen after installation:

1. **Identify GPU before install:**
   ```bash
   lspci -k -nn | grep -A 5 "VGA"
   ```

2. **Use correct installer kernel parameters:**
   - NVIDIA: add `module_blacklist=nouveau nvidia_drm.modeset=1` to boot params
   - AMD: generally works out of the box with `linux-firmware`
   - Intel: generally works out of the box

3. **Install GPU drivers during base install:**
   ```bash
   pacman -S --noconfirm linux-firmware mesa
   # Plus nvidia-dkms if NVIDIA
   ```

4. **Verify boot before installing KDX configs:**
   - Reboot once after base install with just `linux` and `linux-firmware`
   - Confirm GUI works before copying KDX dotfiles

5. **Use LTS kernel if unstable:**
   ```bash
   sudo pacman -S --noconfirm linux-lts linux-lts-headers
   sudo grub-mkconfig -o /boot/grub/grub.cfg
   ```

---

## Known Issues

| GPU | Issue | Fix |
|-----|-------|-----|
| NVIDIA RTX 30/40 | Black screen after boot | Add `nvidia_drm.modeset=1` kernel param + `nvidia.conf` |
| AMD RDNA2/3 | Black screen on external monitor | Set explicit monitor config in `monitors.conf` |
| Intel ARC | Black screen on Hyprland | Use X11 fallback or update to kernel 6.9+ |
| Hybrid Intel+NVIDIA | Black screen on boot | Use `nvidia-dkms` and ensure prime setup |

---

## Getting Help

If the above doesn't fix your issue:

1. Boot from Arch ISO live USB
2. Mount your system and chroot:
   ```bash
   arch-chroot /mnt
   ```
3. Collect logs:
   ```bash
   journalctl -b -p err --no-pager > /tmp/blackscreen-logs.txt
   ```
4. File an issue: https://github.com/KSitharanimsara/knightdragonx-os/issues
   - Include GPU model, kernel version, and logs
