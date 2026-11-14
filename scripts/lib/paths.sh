#!/usr/bin/env bash
# Resolves repository paths and target user directories
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

export CONFIGS_DIR="$REPO_ROOT/configs"
export PROFILES_DIR="$REPO_ROOT/profiles"
export UPSTREAM_DIR="$REPO_ROOT/upstream"
export SYSTEM_DIR="$REPO_ROOT/system"
export PACKAGES_DIR="$REPO_ROOT/packages"

export USER_HOME="${HOME}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$USER_HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$USER_HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$USER_HOME/.local/state}"
export USER_BIN_DIR="${USER_HOME}/.local/bin"
export USER_SYSTEMD_DIR="${XDG_CONFIG_HOME}/systemd/user"

export MANIFEST_FILE="${XDG_STATE_HOME}/arch-files/deployed_manifest.txt"
