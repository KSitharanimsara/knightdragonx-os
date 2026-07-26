# Hotspot Setup

> **Removed:** The KDX WiFi hotspot feature has been removed from the repository.

The Realtek rtw89 driver (`rtw89_8852bte`) does not support reliable AP mode while maintaining a primary WiFi connection. Attempting to run hostapd on this hardware causes the driver to enter a busy state, fails beacon setup, and can disconnect the primary network.

**Why it was removed:**
- `hostapd` fails with `Beacon set failed: -16 (Device or resource busy)` on this chipset
- The rtw89 driver cannot maintain concurrent STA + AP mode on the same radio
- NetworkManager's built-in hotspot also disconnects the primary WiFi (`kdx`)
- Internet access must remain on the primary `kdx` network at all times

**Alternative:**
Use NetworkManager's built-in hotspot if you need temporary sharing:
```bash
nmcli dev wifi hotspot ssid TEMP-HOTSPOT password temppass
```
Note: This will disconnect from `kdx` and must be stopped to restore internet.

---

*This guide is kept for historical reference only.*
