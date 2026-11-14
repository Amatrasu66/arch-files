# Desktop Wallpapers

This directory is intended for desktop wallpapers used by Swaybg, Swaylock, and the desktop environment.

## Licensing & Redistribution Policy
In accordance with open-source licensing compliance, third-party wallpapers without verifiable open redistribution licenses (such as Creative Commons CC0 or CC-BY) are **excluded from public Git publication**.

## Providing Your Wallpaper
The default desktop configuration expects a wallpaper at:
`~/.config/backgrounds/wallpaper.jpg`

You can place your preferred image directly into this directory as `laundry.jpg` (or any image of your choice), or configure Swaybg in `~/.config/systemd/user/swaybg.service`:
```ini
ExecStart=/usr/bin/swaybg -i %h/.config/backgrounds/wallpaper.jpg -m fill
```
