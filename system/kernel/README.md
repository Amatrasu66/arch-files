# Kernel & Command-Line Parameters

- Kernel: `Linux 7.2.14-arch1-1` (x86_64)
- Parameters: `root=PARTUUID=... zswap.enabled=0 rw rootfstype=ext4`
- Note: `zswap.enabled=0` ensures that zswap does not conflict with the active compressed `zram0` device.
