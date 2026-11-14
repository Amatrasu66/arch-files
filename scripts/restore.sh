#!/usr/bin/env bash
# Restore backup from specified directory or latest backup
set -euo pipefail

TARGET_HOME="${USER_HOME:-$HOME}"
BACKUP_DIR="${1:-}"

if [[ -z "$BACKUP_DIR" ]]; then
    # Auto-detect latest backup directory
    LATEST_BACKUP=$(find "$TARGET_HOME" -maxdepth 1 -name ".config-backup-*" -type d | sort -r | head -n 1)
    if [[ -n "$LATEST_BACKUP" && -d "$LATEST_BACKUP" ]]; then
        BACKUP_DIR="$LATEST_BACKUP"
        echo "[INFO] Auto-detected latest backup directory: $BACKUP_DIR"
    else
        echo "Usage: $0 <path_to_backup_directory>"
        exit 1
    fi
fi

if [[ ! -d "$BACKUP_DIR" ]]; then
    echo "ERROR: Backup directory not found: $BACKUP_DIR"
    exit 1
fi

echo "Restoring dotfiles from $BACKUP_DIR to $TARGET_HOME..."
cp -a --remove-destination "$BACKUP_DIR"/. "$TARGET_HOME"/
echo "Restoration complete."
