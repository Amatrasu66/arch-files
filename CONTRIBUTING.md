# Contributing to arch-files

We welcome contributions that improve portability, add hardware profiles, and enhance the desktop experience.

## Guidelines
1. **Never commit sensitive data**: No tokens, SSH private keys, personal passwords, or browser profiles.
2. **Modular Architecture**: All configuration changes should be testable via `scripts/validate.sh`.
3. **Evidence-based changes**: Ensure changes work across Wayland compositors (primarily Niri) without breaking systemd session units.
