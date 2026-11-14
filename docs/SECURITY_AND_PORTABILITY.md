# Security & Hardware Portability Audit Report

## 1. Security Audit Findings
- **Excluded Sensitive Files**:
  - SSH Private Keys (`~/.ssh/id_ed25519`) -> Completely excluded from repository.
  - Browser Data (`~/.config/BraveSoftware`, `~/.config/zen`, `~/.config/net.imput.helium`) -> Passwords, cookies, histories, and session databases are excluded.
  - User Tokens (`~/.config/antigravity/plugin-secrets.json`, `credential-user-scope`) -> Excluded.
  - Personal Information -> Git name and email sanitized into template (`configs/shell/gitconfig.template`).
  - Passwords / Wi-Fi Credentials -> NetworkManager connection files in `/etc/NetworkManager/system-connections/` are excluded.

## 2. Portability Classifications
| Component | Classification | Adaptation Method |
|---|---|---|
| `Niri config.kdl` | Hardware-Specific | Output connector name (`HDMI-A-1`) and scale factor (`1.4`) must be tuned for target monitor. |
| `Kitty kitty.conf` | Fully Portable | Works out of the box on any system with Kitty. |
| `Fuzzel fuzzel.ini` | User/Hardware-Specific | Contains `output=HDMI-A-1`; deployer script strips or auto-detects connector. |
| `Zsh / Bash rc` | Fully Portable | Generic shell environment, uses dynamic PATH resolution. |
| `Modesty Shell` | Hardware/Runtime-Specific | Requires `quickshell`, Qt 6 Quick libraries, and Python helper scripts. |
| `Brave flags` | GPU-Specific | Flags are tailored for Intel VA-API (`VaapiVideoDecoder`). AMD/NVIDIA require specific flags. |
| `zram-generator.conf` | Hardware-Specific | Sizes zram based on available physical RAM. |
