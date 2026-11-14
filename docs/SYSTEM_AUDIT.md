# Forensic System Audit Report

## Audit Metadata
- **Audit Timestamp**: 2026-11-14
- **Host**: `archthinkpad` (Lenovo ThinkPad E560)
- **Kernel**: Linux 7.2.14-arch1-1 (x86_64 SMP PREEMPT_DYNAMIC)
- **OS**: Arch Linux (rolling release)
- **Init**: systemd 262.1-1-arch
- **Session**: Wayland (`niri --session`)
- **Firmware**: UEFI 2.40 (Lenovo R00ET68W 1.43, Secure Boot disabled)

## Inspection Summary & Health Check
1. **Filesystem & Partitions**:
   - `/dev/sda1` (1022M FAT32 ESP mounted at `/boot`) - 10% utilized.
   - `/dev/sda2` (175G ext4 root mounted at `/`) - 18% utilized (137G available).
   - `zram0` (3.8G zstd compressed RAM swap) - Active, 613MB used.
2. **Audio System**:
   - PipeWire active, wireplumber managing routing.
   - Bluetooth sink (CMF Buds) and HDMI audio (Panasonic TV) configured.
3. **Power & Session Inactivity**:
   - Custom inactivity daemon managing 10m lock, 1h suspend, and 6h shutdown across boots.
4. **Desktop Shell**:
   - Modesty QuickShell service active and responsive via IPC.
   - 0 crashes reported in journalctl during audit period.
