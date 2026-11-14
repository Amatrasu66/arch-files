# System-Level Configurations Inventory

## Audit of `/etc` and Core Services

| Configuration File | Classification | Status & Purpose |
|---|---|---|
| `/etc/pacman.conf` | Customized | Enabled `Color`, `CheckSpace`, `ParallelDownloads = 5`, `DownloadUser = alpm`. |
| `/etc/fstab` | Hardware-Specific | Root ext4 (`sda2`) and EFI vfat (`sda1`). Template provided in repository. |
| `/etc/mkinitcpio.conf` | Stock / Tailored | Standard hooks: `base udev autodetect microcode modconf kms keyboard keymap consolefont block filesystems fsck`. |
| `/etc/systemd/zram-generator.conf` | Customized | Allocates compressed zram swap partition using zstd algorithm. |
| `/etc/vconsole.conf` | Stock | Sets console keymap to `us` and font to `default8x16`. |
| `/etc/locale.conf` | Stock | Locale set to `en_US.UTF-8`. |
| `/etc/hostname` | Host-Specific | Static hostname `archthinkpad`. |
