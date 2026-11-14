# Bootloader Configuration (systemd-boot)

The reference machine boots via UEFI 2.40 and `systemd-boot`:
- ESP partition: `sda1` (FAT32, mounted at `/boot`)
- Boot entry: `arch-linux.efi` (Unified Kernel Image stub via `systemd-stub`)
- Configuration tool: `bootctl`
