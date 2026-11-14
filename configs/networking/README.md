# Networking Configuration

Networking is handled by `NetworkManager.service` and `wpa_supplicant`:
- CLI client: `nmcli`
- Menu integration: Modesty Wi-Fi drawer and `desktop-quick-settings`
- Connection profiles are kept in `/etc/NetworkManager/system-connections/` (sanitized and excluded from version control).
