#!/usr/bin/env bash
# ~/.local/bin/lock-session
# Integrates with existing Modesty / Dynamic Island lock screen in Quickshell
# Completely replaces Swaylock with native Wayland ext-session-lock-v1
set -euo pipefail

STATE_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/session"
mkdir -p "$STATE_DIR"

LOCK_FILE="$STATE_DIR/lock-session.lock"
LOCKED_AT="$STATE_DIR/locked_at"

# Serialize lock attempts so simultaneous triggers (e.g. idle timeout + logind lock)
# do not race or duplicate lock requests.
exec 9>"$LOCK_FILE"
if ! flock -n 9; then
    exit 0
fi

# Ensure Quickshell service is running
if ! systemctl --user is-active quickshell.service >/dev/null 2>&1; then
    systemctl --user start quickshell.service
    sleep 0.5
fi

# Check if Modesty lock screen is already active
HEALTH=$(quickshell ipc call island health 2>/dev/null || echo "")
if [[ "$HEALTH" =~ \"locked\":true ]]; then
    # Already locked, do nothing
    exit 0
fi

# Track locked timestamp
date +%s > "$LOCKED_AT"

# Trigger existing Dynamic Island / Modesty lock screen via IPC
quickshell ipc call island lock
