# AGENTS.md: AI-Agent Deployment & Configuration Manual

This document is the authoritative instruction manual for AI coding agents tasked with inspecting, auditing, adapting, and deploying this configuration onto a target Arch Linux system.

---

## 1. Core Operating Principles
1. **Never Guess**: Inspect the target machine before modifying any files or running installation commands.
2. **Non-Destructive Auditing**: Always run read-only diagnostics first (`./scripts/audit.sh`).
3. **Backup Before Modification**: Always run `./scripts/backup.sh` before deploying dotfiles or symlinks.
4. **Hardware Adaptation**: Do not assume identical monitor connectors, scale factors, or GPU vendors.
5. **Always Dry-Run First**: Execute `./scripts/configure.sh --dry-run` to preview symlink creation.

---

## 2. Step-by-Step Deployment Workflow

### Phase 1: Target Inspection & Hardware Detection
Run the auditor to inspect the target environment:
```bash
./scripts/audit.sh
```
Check:
- CPU vendor: `lscpu` (Intel vs AMD microcode).
- GPU model: `lspci -k | grep -E "VGA|3D"` (Intel vs AMD vs NVIDIA graphics drivers).
- Display connector: `niri msg outputs` or `wlr-randr` to find active monitor names (e.g. `eDP-1`, `DP-1`, `HDMI-A-1`).
- Physical resolution & scale factor requirements.

### Phase 2: Configuration Adaptation
1. **Display & Scaling**:
   - Inspect `configs/niri/config.kdl`.
   - Update `output "<MONITOR_NAME>"` with the target monitor's name.
   - Adjust `scale` (e.g. 1.0 for 1080p, 1.25 or 1.4 for high DPI / TV displays).
2. **Fuzzel Output**:
   - Check `configs/launcher/fuzzel.ini`. If `output=...` is specified, adjust or remove it to dynamically bind to the active monitor.

### Phase 3: Safety Backup
```bash
./scripts/backup.sh
```
This automatically captures a safety backup of all managed dotfiles into `~/.config-backup-<timestamp>/`.

### Phase 4: System Bootstrap & Package Installation
1. Bootstrap system package managers and AUR helper:
   ```bash
   ./scripts/bootstrap.sh
   ```
2. Install packages according to chosen profile:
   ```bash
   # Dry-run inspection
   ./scripts/install.sh --dry-run default

   # Real installation
   ./scripts/install.sh default
   ```
   *Available profiles*: `default`, `minimal`, `development`.

### Phase 5: Modular Dotfile Deployment
```bash
# Preview
./scripts/configure.sh --dry-run --profile default

# Real deployment
./scripts/configure.sh --profile default
```
*Individual module execution* is supported:
```bash
./scripts/configure.sh --module niri
./scripts/configure.sh --module modesty
./scripts/configure.sh --module terminal
./scripts/configure.sh --module gtk
```

### Phase 6: Service Activation & Verification
Enable and start the user session services:
```bash
systemctl --user daemon-reload
systemctl --user enable --now quickshell.service swaybg.service swayidle.service cliphist.service
```

### Phase 7: Functional & Technical Validation
1. Validate configuration files:
   ```bash
   ./scripts/validate.sh
   ```
2. Verify running services:
   ```bash
   systemctl --user list-units --type=service --state=running
   ```

### Phase 8: Safe Rollback & Uninstallation
If deployment fails or user requests removal:
```bash
# Preview uninstallation
./scripts/uninstall.sh --dry-run

# Execute unlinking
./scripts/uninstall.sh --confirm

# Restore prior backup (auto-detects latest backup, or pass specific path)
./scripts/restore.sh
```
