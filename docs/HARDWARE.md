# Hardware Inventory & Adaptation Specifications

## Reference Hardware Specifications (Lenovo ThinkPad E560)

| Subsystem | Component | Specifications / Driver | Configuration Notes |
|---|---|---|---|
| **Host System** | Lenovo ThinkPad E560 | Type 20EV, BIOS R00ET68W (1.43, 2022-01-26) | UEFI 2.40 boot, Secure Boot disabled |
| **Processor** | Intel Core i5-6200U | Skylake-U 2.30 GHz (2 cores, 4 threads, 3MB L3) | Microcode 0xf0 loaded via `intel-ucode` |
| **Graphics** | Intel HD Graphics 520 | Skylake GT2, PCI ID `8086:1916` (rev 07) | Kernel driver `i915`, Mesa VA-API accelerated |
| **Memory** | 8 GB DDR3L | 7.6 GiB usable, 1.3 GiB free, 2.5 GiB cache | zram swap: 3.8 GiB zstd compressed partition |
| **Storage** | Samsung PM871 SSD | Model `MZ7LF192HCGS-000L1` (192 GB SATA SSD) | Partition `sda1` (1GB ESP), `sda2` (175GB ext4) |
| **Optical Drive** | HL-DT-ST DVDRAM | Model `GUC0N` (SATA DVD-RW) | Mounted at `/dev/sr0` |
| **Display 1 (Internal)** | Chimei Innolux 15.6" | `eDP-1`, native 1366x768 @ 60.003Hz | **Disabled** in Niri (`off`) |
| **Display 2 (External)** | Panasonic TV 40" | `HDMI-A-1`, 1920x1080 @ 60.000Hz | **Active**, scale 1.4x, logical size 1371x771 |
| **Wireless / BT** | Intel Wireless-AC 3165 | Dual Band AC 3165 + Bluetooth 4.2 (`iwlwifi`) | Managed by NetworkManager + bluez |
| **Ethernet** | Intel I219-V | Gigabit Ethernet (`e1000e`) | Managed by NetworkManager |
| **Card Reader** | Realtek RTS522A | PCIe Card Reader (`rtsx_pci`) | Kernel driver active |
| **Audio** | Intel Sunrise Point-LP | HD Audio (`snd_hda_intel`) | Integrated speakers, mic, and HDMI audio |
| **Camera** | Integrated 720p HD | SunplusIT / Vimicro (`uvcvideo`) | `/dev/video0` and `/dev/video1` |
| **Input Devices** | AlpsPS/2 DualPoint | Touchpad + TrackPoint stick | libinput driver |
| **External Input** | Logitech Combo | Wireless Keyboard (PID:4023) + Mouse (PID:4022) | USB receiver on `xhci_hcd` |
| **Battery** | LGC LNV-45N1 | Lithium-Ion, Design 47.52 Wh, Capacity ~2.2% | Degraded battery; system powered primarily via AC |

## Hardware Adaptation Guidelines for Deployment

When deploying to a different machine:
1. **GPU Driver**:
   - Intel: `mesa`, `vulkan-intel`, `intel-media-driver`
   - AMD: `mesa`, `vulkan-radeon`, `libva-mesa-driver`
   - NVIDIA: `nvidia` or `nvidia-open`, `nvidia-utils`
2. **Display Configuration**:
   - Inspect connected monitors with `niri msg outputs`.
   - Update `configs/niri/config.kdl` output blocks for the target's monitor connector name, native resolution, and appropriate scale factor.
3. **CPU Microcode**:
   - Replace `intel-ucode` with `amd-ucode` if deploying to an AMD processor.
