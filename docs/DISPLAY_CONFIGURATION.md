# Display Architecture & Multi-Monitor Configuration

## Reference Configuration
The reference setup uses an external high-definition display connected via HDMI, with the internal laptop panel disabled:

```kdl
output "eDP-1" {
    off
}

output "HDMI-A-1" {
    mode "1920x1080@60.000"
    scale 1.4
    position x=0 y=0
}
```

## Scaling Analysis & Ergonomics
- **Physical Output**: 1920x1080 @ 60.000 Hz.
- **Scale Factor**: `1.4` (Fractional scaling managed natively by Niri under Wayland).
- **Logical Resolution**: `1371x771` effective viewport.
- **Ergonomics**: Provides optimal UI element sizing, comfortable text readability, and prevents eye strain across a 40" display viewing distance.

## Hardware Portability & Adaptation Guide
When running on different hardware:
1. Run `niri msg outputs` to discover available connector identifiers (e.g. `DP-1`, `HDMI-A-2`, `eDP-1`).
2. Adjust `configs/niri/config.kdl`:
   - If using a single laptop display, comment out `off` under `eDP-1` and set `scale 1.0` or `1.25`.
   - If using dual monitors, position them using logical pixel coordinates (e.g. `position x=0 y=0` and `position x=1920 y=0`).
3. Update `configs/launcher/fuzzel.ini` output field (`output=HDMI-A-1`) or set it to empty for auto-detection on the focused output.
