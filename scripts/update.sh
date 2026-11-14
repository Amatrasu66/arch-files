#!/usr/bin/env bash
# Safe repository update script

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "Checking for upstream updates in arch-files repository..."
git -C "$REPO_ROOT" pull --rebase || true
echo "Update check completed."
