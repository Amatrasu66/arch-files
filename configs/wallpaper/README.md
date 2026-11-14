# Wallpaper Management

Wallpapers are stored in `assets/wallpapers/`.
The active wallpaper is managed via `swaybg.service` in `configs/misc/systemd-user/swaybg.service` and deployed to `~/.config/backgrounds/wallpaper.jpg`.
- Active: `assets/wallpapers/laundry.jpg`
- Daemon: `/usr/bin/swaybg -i %h/.config/backgrounds/wallpaper.jpg -m fill`
