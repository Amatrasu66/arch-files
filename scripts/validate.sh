#!/usr/bin/env bash
# Comprehensive repository validator checking syntax, integrity, assets, and portability
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"
source "$SCRIPT_DIR/lib/paths.sh"

ERRORS=0
WARNINGS=0

log_info "=== Validating arch-files Repository Integrity ==="

# 1. Shell Syntax Validation (bash -n)
log_info "1. Checking Shell Scripts Syntax..."
while IFS= read -r sh_file; do
    if bash -n "$sh_file"; then
        log_success "Shell syntax valid: ${sh_file#$REPO_ROOT/}"
    else
        log_error "Shell syntax error: ${sh_file#$REPO_ROOT/}"
        ERRORS=$((ERRORS + 1))
    fi
done < <(find "$REPO_ROOT/scripts" "$REPO_ROOT/configs/misc/bin" "$REPO_ROOT/configs/lockscreen" -type f \( -name "*.sh" -o \( -perm -111 ! -name "*.*" \) \))

# 2. JSON Validation (python3 -m json.tool)
log_info "2. Checking JSON Manifests..."
while IFS= read -r json_file; do
    if python3 -m json.tool "$json_file" >/dev/null 2>&1; then
        log_success "JSON valid: ${json_file#$REPO_ROOT/}"
    else
        log_error "Invalid JSON: ${json_file#$REPO_ROOT/}"
        ERRORS=$((ERRORS + 1))
    fi
done < <(find "$REPO_ROOT" -type f -name "*.json" ! -path "*/.git/*")

# 3. Niri Configuration Validation
log_info "3. Checking Niri Compositor Configuration..."
if command -v niri >/dev/null 2>&1; then
    if niri validate --config "$CONFIGS_DIR/niri/config.kdl" >/dev/null 2>&1; then
        log_success "Niri configuration is valid"
    else
        log_error "Niri configuration validation failed"
        ERRORS=$((ERRORS + 1))
    fi
else
    log_warn "Niri validator not installed on host (skipping live niri validate)"
    WARNINGS=$((WARNINGS + 1))
fi

# 4. Systemd User Units Validation
log_info "4. Checking Systemd User Service Units..."
if command -v systemd-analyze >/dev/null 2>&1; then
    UNIT_ERRORS=0
    for s_file in "$CONFIGS_DIR/misc/systemd-user/"*.service; do
        [[ -L "$s_file" ]] && continue # Skip masked units pointing to /dev/null
        if ! systemd-analyze verify --user "$s_file" >/dev/null 2>&1; then
            log_error "Systemd unit invalid: $(basename "$s_file")"
            UNIT_ERRORS=$((UNIT_ERRORS + 1))
        fi
    done
    if [[ $UNIT_ERRORS -eq 0 ]]; then
        log_success "All systemd user service units are valid"
    else
        ERRORS=$((ERRORS + UNIT_ERRORS))
    fi
else
    log_warn "systemd-analyze not installed on host"
    WARNINGS=$((WARNINGS + 1))
fi

# 5. GTK Referenced Assets Verification
log_info "5. Verifying GTK Referenced SVG Assets..."
GTK_ASSETS_DIR="$CONFIGS_DIR/gtk/assets"
MISSING_ASSETS=0
for css in "$CONFIGS_DIR/gtk/gtk3.css" "$CONFIGS_DIR/gtk/gtk4.css"; do
    if [[ -f "$css" ]]; then
        refs=$(grep -o 'url("assets/[^"]*")' "$css" | sed 's/url("assets\///;s/")//' | sort -u)
        for ref in $refs; do
            if [[ ! -f "$GTK_ASSETS_DIR/$ref" ]]; then
                log_error "Missing GTK asset: $ref (referenced in $(basename "$css"))"
                MISSING_ASSETS=$((MISSING_ASSETS + 1))
            fi
        done
    fi
done
if [[ $MISSING_ASSETS -eq 0 ]]; then
    log_success "All referenced GTK SVG assets are verified present."
else
    ERRORS=$((ERRORS + MISSING_ASSETS))
fi

# 6. Modesty Custom Additions Verification
log_info "6. Verifying Modesty Customization Additions..."
REQUIRED_MODESTY_FILES=(
    "modules/island/AiAgentPill.qml"
    "modules/shortcuts/ShortcutReference.qml"
    "scripts/ai-agent-status.py"
    "scripts/sync_shortcuts.py"
    "services/CommandHistory.qml"
    "services/CommandProviders.js"
    "services/Compositor.qml"
    "integrations/compositor/capabilities.json"
    "integrations/compositor/CompositorAdapter.qml"
    "integrations/compositor/NiriAdapter.qml"
    "config/shortcuts/shortcut_registry.json"
)
MISSING_MODESTY=0
for item in "${REQUIRED_MODESTY_FILES[@]}"; do
    if [[ ! -f "$UPSTREAM_DIR/modesty/additions/$item" ]]; then
        log_error "Missing Modesty addition: $item"
        MISSING_MODESTY=$((MISSING_MODESTY + 1))
    fi
done
if [[ $MISSING_MODESTY -eq 0 ]]; then
    log_success "All required Modesty custom additions are verified present."
else
    ERRORS=$((ERRORS + MISSING_MODESTY))
fi

# 7. Zero Hardcoded User Path Verification
TARGET_USER_PATTERN="/home/"$(echo "amatrasu")
log_info "7. Checking for Unintended Hardcoded User Paths ($TARGET_USER_PATTERN)..."
LEAKED_PATHS=0
while IFS= read -r match; do
    log_error "Hardcoded path found: $match"
    LEAKED_PATHS=$((LEAKED_PATHS + 1))
done < <(grep -rn --exclude="validate.sh" "$TARGET_USER_PATTERN" "$CONFIGS_DIR" "$REPO_ROOT/scripts" "$SYSTEM_DIR" "$UPSTREAM_DIR/modesty/additions" "$UPSTREAM_DIR/modesty/patches" 2>/dev/null || true)

if [[ $LEAKED_PATHS -eq 0 ]]; then
    log_success "Zero hardcoded user paths in active configurations and scripts."
else
    ERRORS=$((ERRORS + LEAKED_PATHS))
fi

# 8. Profile Manifests Verification
log_info "8. Verifying Profile Manifests..."
for prof in default minimal development; do
    p_dir="$PROFILES_DIR/$prof"
    if [[ -f "$p_dir/profile.json" && -f "$p_dir/packages.txt" && -f "$p_dir/modules.txt" ]]; then
        log_success "Profile '$prof' complete (manifest, packages, modules)"
    else
        log_error "Profile '$prof' is missing definition files"
        ERRORS=$((ERRORS + 1))
    fi
done

# Final Summary
echo ""
if [[ $ERRORS -eq 0 ]]; then
    log_success "=== ALL REPOSITORY VALIDATIONS PASSED (Errors: 0, Warnings: $WARNINGS) ==="
    exit 0
else
    log_error "=== VALIDATION FAILED WITH $ERRORS ERROR(S) (Warnings: $WARNINGS) ==="
    exit 1
fi
