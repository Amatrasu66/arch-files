# Troubleshooting & Operational Guide

This guide covers common issues, diagnostics, and operational remedies for the `arch-files` desktop environment.

---

## 1. Display & Compositor Diagnostics

### 1.1 Blank Screen or Wrong Monitor Output
* **Symptom:** Display remains blank or starts on an unintended monitor upon launching Niri.
* **Diagnosis:** Niri binds display output rules by hardware connector name. The default reference configuration binds `HDMI-A-1`.
* **Fix:**
  1. Switch to a TTY (`Ctrl+Alt+F3`).
  2. Query active monitor names:
     ```bash
     niri msg outputs
     ```
  3. Edit `~/.config/niri/config.kdl` and locate the `output` block:
     ```kdl
     output "eDP-1" { // Replace HDMI-A-1 with your connector (e.g. eDP-1, DP-1)
         mode "1920x1080@60"
         scale 1.0
     }
     ```
  4. Save and reload Niri with `Mod+Shift+R` or restart the session.

### 1.2 HiDPI / Scaling Blur or Incorrect Scale
* **Symptom:** Interface appears too small or overly enlarged.
* **Fix:** Adjust the `scale` value in `~/.config/niri/config.kdl`. For typical 1080p laptop displays, `scale 1.0` or `1.25` is recommended. For 4K displays, use `1.5` or `2.0`. Fractional scaling is handled natively by Niri with Wayland clients.

---

## 2. Desktop Shell: Modesty (QuickShell)

### 2.1 Modesty Dynamic Island Does Not Appear
* **Symptom:** Wallpaper loads, but the Dynamic Island top pill does not render.
* **Diagnosis:** QuickShell service failed to start or encountered a missing QML dependency.
* **Fix:**
  1. Inspect the systemd user service status:
     ```bash
     systemctl --user status quickshell.service
     ```
  2. Launch QuickShell interactively in a terminal to inspect real-time QML errors:
     ```bash
     quickshell
     ```
  3. Verify that `~/.config/quickshell` correctly points to your Modesty installation:
     ```bash
     readlink ~/.config/quickshell
     # Expected: $HOME/App/Modesty
     ```
  4. Ensure all required Qt6 declarative modules and Python dependencies are present:
     ```bash
     sudo pacman -S --needed quickshell qt6-declarative qt6-5compat python
     ```

### 2.2 Dynamic Island Audio Visualizer (Cava) Stalled
* **Symptom:** Music is playing, but audio bars inside Modesty do not animate.
* **Fix:**
  1. Verify Cava configuration exists at `~/.config/modesty/cava.conf`.
  2. Check that PipeWire audio is capturing your active output:
     ```bash
     wpctl status
     ```
  3. Ensure `cava` is installed and can read audio from PipeWire.

---

## 3. Session Locking & Idle Management

### 3.1 Lock Screen Authentication Fails
* **Symptom:** Swaylock does not accept your password or displays an authentication error.
* **Diagnosis:** Swaylock requires PAM configuration at `/etc/pam.d/swaylock`.
* **Fix:**
  1. Check if `/etc/pam.d/swaylock` exists. If missing, copy from system template:
     ```bash
     sudo cp /etc/pam.d/system-auth /etc/pam.d/swaylock
     ```
  2. Test lock manually from a terminal:
     ```bash
     lock-session
     ```

### 3.2 System Suspends Unexpectedly or Inactivity Fails
* **Symptom:** System does not lock after 10 minutes of inactivity.
* **Fix:**
  1. Verify `swayidle.service` is running:
     ```bash
     systemctl --user status swayidle.service
     ```
  2. Ensure `session-inactivity-manager` helper is executable:
     ```bash
     chmod +x ~/.local/bin/session-inactivity-manager
     ```
  3. Inspect power management log:
     ```bash
     journalctl --user-unit=swayidle.service -b
     ```

---

## 4. Audio & Media Controls

### 4.1 No Audio or Sound Routed to Incorrect Device
* **Symptom:** Audio playback produces no sound or plays through built-in speakers instead of headphones/Bluetooth.
* **Fix:**
  1. Query available sinks:
     ```bash
     wpctl status
     ```
  2. Find your desired Sink ID and set it as the system default:
     ```bash
     wpctl set-default <SINK_ID>
     ```
  3. Unmute volume if muted:
     ```bash
     wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
     wpctl set-volume @DEFAULT_AUDIO_SINK@ 50%
     ```

### 4.2 Media Player Keys (`XF86AudioPlay`, etc.) Not Responding
* **Symptom:** Keyboard media shortcuts do not control music playback.
* **Fix:** Ensure `playerctl` is installed and an MPRIS-compatible media player (e.g. Brave, Spotify, MPV) is running. Test with:
  ```bash
  playerctl status
  playerctl play-pause
  ```

---

## 5. Clipboard & Application Launcher

### 5.1 Clipboard History (`Mod+V`) Empty
* **Symptom:** Pressing `Mod+V` shows an empty Fuzzel menu even after copying text.
* **Fix:**
  1. Check that `cliphist` and `wl-clipboard` are installed:
     ```bash
     sudo pacman -S --needed wl-clipboard cliphist
     ```
  2. Verify that the clipboard watcher service is active:
     ```bash
     systemctl --user status cliphist.service
     ```
  3. If inactive, start it:
     ```bash
     systemctl --user enable --now cliphist.service
     ```

### 5.2 Fuzzel Does Not Open on Correct Monitor
* **Symptom:** Fuzzel launcher opens on an inactive or disconnected display.
* **Fix:** In `~/.config/fuzzel/fuzzel.ini`, remove or comment out any explicit `output=` line to allow Fuzzel to dynamically attach to the currently focused display.

---

## 6. Rollback & Disaster Recovery

### 6.1 Reverting Accidental Deployment Changes
If a configuration change breaks your desktop:
1. **Auto-Rollback:** Run the restore tool to reinstate the latest safety backup:
   ```bash
   ./scripts/restore.sh
   ```
2. **Safe Uninstallation:** Remove all managed symlinks without deleting personal files:
   ```bash
   ./scripts/uninstall.sh --confirm
   ```
3. **Manual Backup Archive:** Pre-deployment backups are preserved in:
   ```bash
   ls -ld ~/.config-backup-*
   ```
