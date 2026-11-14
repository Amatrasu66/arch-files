#!/usr/bin/env bash
# Common logging, colors, and utility functions
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[INFO]${NC} $*"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $*"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $*"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $*" >&2
}

detect_hardware() {
    log_info "Detecting system hardware..."
    local cpu_vendor gpu_info total_ram chassis
    cpu_vendor=$(lscpu 2>/dev/null | grep "Vendor ID:" | awk '{print $3}' || echo "Unknown")
    gpu_info=$(lspci -k 2>/dev/null | grep -A 2 -E "VGA|3D" | head -n 3 || echo "Unknown")
    total_ram=$(free -h 2>/dev/null | awk '/^Mem:/ {print $2}' || echo "Unknown")
    chassis=$(hostnamectl status 2>/dev/null | awk '/Chassis:/ {print $2}' || echo "desktop/unknown")
    
    log_info "CPU: $cpu_vendor | RAM: $total_ram | Chassis: $chassis"
    log_info "GPU: $(echo "$gpu_info" | head -n 1)"
}
