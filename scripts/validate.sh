#!/usr/bin/env bash
# Comprehensive repository validator checking syntax, integrity, assets, and portability.
# Designed to run portably on standard environments (including Ubuntu CI and Arch Linux).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"
source "$SCRIPT_DIR/lib/paths.sh"

ERRORS=0
WARNINGS=0

log_info "=== Validating arch-files Repository Integrity (Portable Checks) ==="

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

# 2. Python Scripts Syntax Validation (python3 -m py_compile)
log_info "2. Checking Python Scripts Syntax..."
while IFS= read -r py_file; do
    if python3 -m py_compile "$py_file" >/dev/null 2>&1; then
        log_success "Python syntax valid: ${py_file#$REPO_ROOT/}"
    else
        log_error "Python syntax error: ${py_file#$REPO_ROOT/}"
        ERRORS=$((ERRORS + 1))
    fi
done < <(find "$REPO_ROOT" -type f -name "*.py" ! -path "*/.git/*")

# 3. JSON Validation (python3 -m json.tool)
log_info "3. Checking JSON Manifests..."
while IFS= read -r json_file; do
    if python3 -m json.tool "$json_file" >/dev/null 2>&1; then
        log_success "JSON valid: ${json_file#$REPO_ROOT/}"
    else
        log_error "Invalid JSON: ${json_file#$REPO_ROOT/}"
        ERRORS=$((ERRORS + 1))
    fi
done < <(find "$REPO_ROOT" -type f -name "*.json" ! -path "*/.git/*")

# 4. Systemd User Units Static Validation
log_info "4. Checking Systemd User Service Units Structure & Syntax..."
if python3 "$SCRIPT_DIR/validate-units.py"; then
    log_success "All systemd user service units passed structural and directive validation."
else
    log_error "Systemd unit validation failed."
    ERRORS=$((ERRORS + 1))
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
done < <(grep -rn --exclude="validate.sh" --exclude="validate-arch.sh" "$TARGET_USER_PATTERN" "$CONFIGS_DIR" "$REPO_ROOT/scripts" "$SYSTEM_DIR" "$UPSTREAM_DIR/modesty/additions" "$UPSTREAM_DIR/modesty/patches" --binary-files=without-match 2>/dev/null || true)

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

# 9. Target-Environment Validation (optional / run if target tools are present)
log_info "9. Checking Target-Environment Tooling (Optional in portable mode)..."
if command -v niri >/dev/null 2>&1; then
    if niri validate --config "$CONFIGS_DIR/niri/config.kdl" >/dev/null 2>&1; then
        log_success "Niri configuration is valid (live check)"
    else
        log_error "Niri configuration validation failed"
        ERRORS=$((ERRORS + 1))
    fi
else
    log_warn "Niri validator not found on this runner (validated in Arch environment CI job)"
    WARNINGS=$((WARNINGS + 1))
fi

# Final Summary
echo ""
if [[ $ERRORS -eq 0 ]]; then
    log_success "=== ALL PORTABLE REPOSITORY VALIDATIONS PASSED (Errors: 0, Warnings: $WARNINGS) ==="
    exit 0
else
    log_error "=== VALIDATION FAILED WITH $ERRORS ERROR(S) (Warnings: $WARNINGS) ==="
    exit 1
fi
