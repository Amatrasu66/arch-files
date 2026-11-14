#!/usr/bin/env bash
# Backup target machine configuration before deployment
set -euo pipefail

TARGET_HOME="${USER_HOME:-$HOME}"
BACKUP_DIR="${TARGET_HOME}/.config-backup-$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

echo "Creating safety backup of dotfiles into $BACKUP_DIR..."
for item in .config/niri .config/kitty .config/fuzzel .config/modesty .config/swayidle .config/swaylock .zshrc .bashrc .local/bin; do
    if [[ -e "$TARGET_HOME/$item" ]]; then
        mkdir -p "$BACKUP_DIR/$(dirname "$item")"
        cp -a "$TARGET_HOME/$item" "$BACKUP_DIR/$item"
        echo "Backed up $TARGET_HOME/$item"
    fi
done
echo "Backup complete: $BACKUP_DIR"
