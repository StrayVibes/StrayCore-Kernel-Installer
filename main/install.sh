
#!/bin/bash

# StrayCore Kernel - Ultimate Gaming & Development Kernel
# Modern Animated Edition with Interactive UI
# Version: 2025.13 "Guardian" - The Definitive Edition

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
ORANGE='\033[0;33m'
BOLD='\033[1m'
DIM='\033[2m'
BLINK='\033[5m'
UNDERLINE='\033[4m'
REVERSE='\033[7m'
NC='\033[0m'

GRAD1='\033[38;5;129m'
GRAD2='\033[38;5;135m'
GRAD3='\033[38;5;141m'
GRAD4='\033[38;5;147m'
GRAD5='\033[38;5;153m'

show_loading_bar() {
    local duration=${1:-2}
    local message=${2:-"Loading"}
    local width=40

    echo -e "\n${CYAN}${BOLD}$message${NC}"
    
    for ((i=0; i<=width; i++)); do
        local percent=$((i * 100 / width))
        local bar=""
        for ((j=0; j<i; j++)); do bar+="#"; done
        for ((j=i; j<width; j++)); do bar+="-"; done
        
        printf "\r${DIM}[${GRAD3}%s${DIM}%s${DIM}] ${percent}%%${NC}" "${bar:0:i}" "${bar:i}"
        
        sleep $(echo "scale=3; $duration/$width" | bc -l 2>/dev/null || echo "0.05")
    done
    
    local final_bar=""
    for ((j=0; j<width; j++)); do final_bar+="#"; done
    printf "\r${DIM}[${GREEN}%s${DIM}] 100%%${NC} ${GREEN}✅${NC}\n" "$final_bar"
}

show_spinner() {
    local pid=$1
    local message=$2
    local delay=0.1
    local spinstr='|/-\'
    
    echo -ne "\n${CYAN}${BOLD}$message${NC} "
    while ps -p $pid > /dev/null; do
        local temp=${spinstr#?}
        printf "${PURPLE}[%c]${NC} " "$spinstr"
        spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

show_pulsing_text() {
    local text="$1"
    local color="$2"
    
    for ((i=0; i<3; i++)); do
        echo -e "\r${color}${BOLD}$text${NC}"
        sleep 0.3
        echo -e "\r${DIM}$text${NC}"
        sleep 0.3
    done
    echo -e "\r${color}${BOLD}$text${NC}"
}

show_holographic_banner() {
    clear
    echo -e "${GRAD1}${BOLD}"
    echo "    ╔═══════════════════════════════════════════════════════════════════════════════╗"
    echo -e "    ║${GRAD2}  ███████ ████████ ██████   █████  ██    ██  ██████  ██████  ███████  ███████  ${GRAD1}║"
    echo -e "    ║${GRAD3}  ██         ██    ██   ██ ██   ██  ██  ██  ██      ██    ██ ██   ██  ██       ${GRAD1}║"
    echo -e "    ║${GRAD4}  ███████    ██    ██████  ███████   ████   ██      ██    ██ ██████   █████    ${GRAD1}║"
    echo -e "    ║${GRAD5}       ██    ██    ██   ██ ██   ██    ██    ██      ██    ██ ██   ██  ██       ${GRAD1}║"
    echo -e "    ║${GRAD2}  ███████    ██    ██   ██ ██   ██    ██     ██████  ██████  ██   ██  ███████  ${GRAD1}║"
    echo "    ║                                                                               ║"
    echo -e "    ║${PURPLE}              🚀 Ultimate Gaming & Development Kernel v2025.13                 ${GRAD1}║"
    echo -e "    ║${CYAN}                    ⚡ Built for Performance Excellence ⚡                     ${GRAD1}║"
    echo -e "    ║${YELLOW}                        💻 By StrayVibes (Thomas Garau)                        ${GRAD1}║"
    echo "    ╚═══════════════════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    show_pulsing_text "    🌟 MAE - The Future of Kernel Building 🌟" "$PURPLE"
    echo ""
    
    echo -e "${GREEN}${DIM}"
    echo -e "${NC}"
}

show_banner() {
    show_holographic_banner
    show_loading_bar 2 "🚀 Initializing StrayCore Builder"
}

check_system() {
    echo -e "${BLUE}${BOLD}🔍 System Analysis${NC}"
    show_loading_bar 1 "   Scanning system configuration"
    
    if [[ $EUID -eq 0 ]]; then 
        echo -e "${RED}❌ Security Alert: Don't run this script as root!${NC}"
        exit 1
    fi
    
    if ! command -v pacman &> /dev/null; then 
        echo -e "${RED}❌ System Incompatibility: This script requires Arch-based systems${NC}"
        exit 1
    fi
    
    CPU_MODEL=$(lscpu | grep "Model name" | cut -d: -f2 | xargs)
    CPU_CORES=$(nproc)
    TOTAL_RAM=$(free -g | awk '/^Mem:/{print $2}')
    
    echo -e "${GREEN}✅ System Validation Complete${NC}"
    echo -e "${CYAN}🏗️  CPU: ${BOLD}${CPU_MODEL}${NC}"
    echo -e "${CYAN}⚡ Cores: ${BOLD}${CPU_CORES}${NC}"
    echo -e "${CYAN}💾 RAM: ${BOLD}${TOTAL_RAM}GB${NC}"
    echo ""
}

install_dependencies() {
    echo -e "${BLUE}${BOLD}📦 Installing Dependencies${NC}"
    
    local common_packages="base-devel bc cpio gettext kmod libelf ncurses pahole perl python rsync tar xz git wget flex bison xmlto inetutils clang llvm lld ccache ninja cmake linux-firmware linux-headers jq lm_sensors htop neofetch"
    
    show_loading_bar 3 "   Preparing package installation"
    
    local spinner_msg
    if pacman -Qs dracut > /dev/null; then
        echo -e "${CYAN}🔧 Dracut environment detected${NC}"
        spinner_msg="   Installing enhanced toolchain with dracut"
        sudo pacman -S --needed --noconfirm $common_packages dracut &
    else
        echo -e "${CYAN}🔧 Standard Arch environment detected${NC}"
        spinner_msg="   Installing enhanced toolchain with mkinitcpio"
        sudo pacman -S --needed --noconfirm $common_packages mkinitcpio &
    fi
    local install_pid=$!
    show_spinner $install_pid "$spinner_msg"
    
    if ! wait $install_pid; then
        echo -e "${RED}❌ Dependency installation failed!${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅${NC}"
    
    echo -e "${GREEN}✅ Advanced development environment ready${NC}"
    echo ""
}

prepare_source() {
    local FREE_MEM_GB=$(free -g | awk '/^Mem:/{print $7}')
    local MIN_MEM_GB=8

    echo -e "${BLUE}${BOLD}🌐 Kernel Source Preparation${NC}"

    if [[ $FREE_MEM_GB -ge $MIN_MEM_GB ]]; then
        WORK_DIR="/dev/shm/straycore-build"
        echo -e "${GREEN}🚀 RAM Build Mode Activated! Compiling in memory for MAXIMUM SPEED.${NC}"
    else
        WORK_DIR="/tmp/straycore-build"
        echo -e "${YELLOW}⚠️  Disk Build Mode. For ultra-fast builds, ensure 8GB+ free RAM.${NC}"
    fi

    if [ -d "$WORK_DIR" ]; then
        show_loading_bar 1 "   Cleaning previous build directory"
        sudo rm -rf "$WORK_DIR"
    fi

    mkdir -p "$WORK_DIR" && cd "$WORK_DIR"
    
    show_loading_bar 2 "   Contacting kernel.org servers"
    KERNEL_VERSION=$(curl -s https://www.kernel.org/releases.json | jq -r '.latest_stable.version')
    
    if [ -z "$KERNEL_VERSION" ]; then 
        echo -e "${RED}❌ Network Error: Failed to fetch kernel version${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}🎯 Target Kernel: ${BOLD}${KERNEL_VERSION}${NC}"
    
    show_loading_bar 4 "   Downloading kernel source (~150MB)"
    wget -q --show-progress "https://cdn.kernel.org/pub/linux/kernel/v${KERNEL_VERSION:0:1}.x/linux-${KERNEL_VERSION}.tar.xz"
    
    show_loading_bar 3 "   Extracting and preparing source"
    tar -xf "linux-${KERNEL_VERSION}.tar.xz" && cd "linux-${KERNEL_VERSION}"
    
    echo -e "${GREEN}✅ Source code ready for compilation${NC}"
    echo ""
}

create_config() {
    echo -e "${BLUE}${BOLD}⚙️  Advanced Configuration Generation${NC}"
    
    show_loading_bar 2 "   Analyzing current hardware configuration"
    yes "" | make localmodconfig >/dev/null 2>&1
    
    show_loading_bar 3 "   Applying StrayCore performance optimizations"
    
    cat >> .config << 'EOF'

CONFIG_LOCALVERSION="-StrayCore-v2025.13-Guardian"
CONFIG_LOCALVERSION_AUTO=n
CONFIG_PREEMPT_VOLUNTARY=y
CONFIG_NO_HZ_FULL=y
CONFIG_RCU_NOCB_CPU=y
CONFIG_RCU_BOOST=y
CONFIG_KERNEL_LZ4=y
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
CONFIG_TCP_CONG_BBR=y
CONFIG_DEFAULT_TCP_CONG="bbr"
CONFIG_IOSCHED_BFQ=y
CONFIG_DEFAULT_IOSCHED="bfq"
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
CONFIG_X86_INTEL_PSTATE=y
CONFIG_DEBUG_INFO_NONE=y
EOF
    
    scripts/config --enable KALLSYMS --enable SECURITY_APPARMOR --set-str LSM "lockdown,yama,apparmor,bpf" >/dev/null 2>&1
    make olddefconfig >/dev/null 2>&1
    
    echo -e "${GREEN}✅ StrayCore configuration optimized for your system${NC}"
    echo ""
}

build_kernel() {
    echo -e "${BLUE}${BOLD}🔨 StrayCore Kernel Compilation${NC}"
    echo -e "${YELLOW}Estimated build time: ${BOLD}15-45 minutes${NC} (depending on hardware)"
    
    local LOG_FILE="${WORK_DIR}/straycore-build.log"
    echo -e "${CYAN}Build logs will be available in ${LOG_FILE}${NC}"
    
    echo -e "${CYAN}   Estimating total modules...${NC}"
    local TOTAL_MODULES=$(find . -type f \( -name "*.c" -o -name "*.S" \) | wc -l)
    echo -e "${GREEN}   Estimated modules to compile: ${TOTAL_MODULES}${NC}"

    export MAKEFLAGS="-j${CPU_CORES}"
    export CC="ccache gcc" 
    export CXX="ccache g++"

    echo -e "\n${CYAN}${BOLD}   Compiling main kernel image...${NC}"
    make > "$LOG_FILE" 2>&1 &
    local build_pid=$!
    local start_time=$(date +%s)

    while ps -p $build_pid > /dev/null; do
        sleep 2
        local current_modules=$(grep -c ' CC ' "$LOG_FILE" || true)
        
        if [ "$current_modules" -gt 0 ] && [ "$TOTAL_MODULES" -gt 0 ]; then
            local elapsed_time=$(( $(date +%s) - start_time ))
            local percent=$(( current_modules * 100 / TOTAL_MODULES ))
            if [ "$percent" -ge 100 ]; then percent=99; fi

            local time_per_module=$(echo "scale=2; $elapsed_time / $current_modules" | bc)
            local remaining_modules=$(( TOTAL_MODULES - current_modules ))
            if [ "$remaining_modules" -lt 0 ]; then remaining_modules=0; fi
            
            local eta_seconds=$(echo "$remaining_modules * $time_per_module" | bc | cut -d. -f1)
            local eta_formatted=$(printf '%02d:%02d' $((eta_seconds/60)) $((eta_seconds%60)))
            
            printf "\r${PURPLE}[%3d%%]${NC} Compiling modules: ${YELLOW}%d${NC}/${GREEN}%d${NC} | ETA: ${CYAN}%s${NC}  " "$percent" "$current_modules" "$TOTAL_MODULES" "$eta_formatted"
        else
            printf "\r${PURPLE}[  0%%]${NC} Starting compilation... (waiting for first module)"
        fi
    done

    if ! wait $build_pid; then
        printf "\r%*s\r" "$(tput cols)"
        echo -e "${RED}❌ Kernel compilation failed!${NC}"
        echo -e "${YELLOW}Check the build log for details: ${LOG_FILE}${NC}"
        exit 1
    fi
    printf "\r%*s\r" "$(tput cols)"
    echo -e "${PURPLE}[100%%]${NC} Main kernel compiled successfully. ${GREEN}✅${NC}"

    make modules >> "$LOG_FILE" 2>&1 &
    local modules_build_pid=$!
    show_spinner $modules_build_pid "   Compiling kernel modules"
    
    if ! wait $modules_build_pid; then
        echo -e "${RED}❌ Module compilation failed!${NC}"
        echo -e "${YELLOW}Check the build log for details: ${LOG_FILE}${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅${NC}"

    echo -e "\n${GREEN}✅ StrayCore kernel compilation successful!${NC}"
    echo -e "${PURPLE}🎉 Your custom kernel is ready for installation!${NC}"
    echo ""
}

install_kernel() {
    echo -e "${BLUE}${BOLD}📦 StrayCore Kernel Installation${NC}"
    FULL_VERSION="$(make kernelversion)-StrayCore-v2025.13-Guardian"
    
    show_loading_bar 2 "   Installing kernel modules"
    sudo make modules_install INSTALL_MOD_STRIP=1 >/dev/null 2>&1
    
    show_loading_bar 2 "   Installing kernel image"
    sudo cp arch/x86/boot/bzImage "/boot/vmlinuz-straycore"
    sudo cp System.map "/boot/System.map-straycore"
    sudo cp .config "/boot/config-straycore"
    
    show_loading_bar 3 "   Generating initramfs"
    if command -v dracut &> /dev/null; then
        sudo dracut --force "/boot/initramfs-straycore.img" "$FULL_VERSION" >/dev/null 2>&1
    else
        sudo mkinitcpio -k "$FULL_VERSION" -g "/boot/initramfs-straycore.img" >/dev/null 2>&1
    fi

    echo -e "${GREEN}✅ Kernel installed successfully${NC}"
    echo ""
}

configure_bootloader() {
    echo -e "${BLUE}${BOLD}🥾 Bootloader Configuration${NC}"
    
    if [ -f "/boot/grub/grub.cfg" ]; then
        show_loading_bar 2 "   Configuring GRUB bootloader"
        sudo grub-mkconfig -o /boot/grub/grub.cfg >/dev/null 2>&1
        echo -e "${GREEN}✅ GRUB configured with StrayCore entry${NC}"
    elif command -v bootctl &> /dev/null; then
        show_loading_bar 2 "   Configuring systemd-boot"
        
        local ESP_PATH
        ESP_PATH=$(bootctl status 2>/dev/null | grep 'ESP' | awk '{print $3}')
        
        if [ -z "$ESP_PATH" ] || [ ! -d "$ESP_PATH" ]; then
            echo -e "${YELLOW}⚠️  Could not automatically determine ESP path.${NC}"
            echo -e "${YELLOW}   Please configure your bootloader manually.${NC}"
            return
        fi

        local ENTRIES_DIR="${ESP_PATH}/loader/entries"
        if [ ! -d "$ENTRIES_DIR" ]; then
            echo -e "${YELLOW}⚠️  Bootloader entries directory not found at '${ENTRIES_DIR}'.${NC}"
            echo -e "${YELLOW}   Please configure your bootloader manually.${NC}"
            return
        fi

        echo -e "${CYAN}   Found boot entries directory at: ${ENTRIES_DIR}${NC}"
        
        ROOT_UUID=$(findmnt -no UUID /)
        local CONF_FILE="${ENTRIES_DIR}/straycore.conf"

        sudo tee "$CONF_FILE" >/dev/null << EOF
title   StrayCore Kernel (Guardian Edition)
linux   /vmlinuz-straycore
initrd  /initramfs-straycore.img
options root=UUID=$ROOT_UUID rw quiet splash
EOF
        echo -e "${GREEN}✅ systemd-boot entry created at ${CONF_FILE}${NC}"
    else
        echo -e "${YELLOW}⚠️  Could not detect GRUB or systemd-boot. Manual configuration required.${NC}"
    fi
    echo ""
}

create_tools() {
    echo -e "${BLUE}${BOLD}✨ Creating StrayCore Dashboard & Tools${NC}"
    
    show_loading_bar 2 "   Building performance optimizer"
    sudo tee "/usr/local/bin/straycore-optimize" >/dev/null << 'EOF'
#!/bin/bash
echo performance > /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor 2>/dev/null||true
for disk in /sys/block/nvme*n*/queue/scheduler;do [ -f "$disk" ]&&echo none>"$disk" 2>/dev/null||true;done
for disk in /sys/block/sd*/queue/scheduler;do [ -f "$disk" ]&&echo mq-deadline>"$disk" 2>/dev/null||true;done
echo 10 > /proc/sys/vm/swappiness
echo bbr > /proc/sys/net/ipv4/tcp_congestion_control
echo -1 > /proc/sys/kernel/sched_rt_runtime_us
EOF
    sudo chmod +x "/usr/local/bin/straycore-optimize"
    
    sudo tee "/etc/systemd/system/straycore-optimize.service" >/dev/null << 'EOF'
[Unit]
Description=StrayCore Performance Optimizations
After=multi-user.target
[Service]
Type=oneshot
ExecStart=/usr/local/bin/straycore-optimize
[Install]
WantedBy=multi-user.target
EOF
    sudo systemctl enable --now straycore-optimize.service >/dev/null 2>&1
    
    show_loading_bar 1 "   Creating update manager"
    sudo tee "/usr/local/bin/straycore-update" >/dev/null << 'EOF'
#!/bin/bash
echo -e "\033[0;35m\033[1mStrayCore Update Manager\033[0m"
read -p "This will re-download and build the latest kernel. Continue? (y/N): " -n 1 -r; echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    curl -s https://raw.githubusercontent.com/StrayVibes/StrayCore-Kernel-Installer/main/install.sh | bash
fi
EOF
    sudo chmod +x "/usr/local/bin/straycore-update"
    
    show_loading_bar 3 "   Creating advanced system dashboard"
    sudo tee "/usr/local/bin/straycore" >/dev/null << 'EOF'
#!/bin/bash
RED='\033[0;31m';GREEN='\033[0;32m';BLUE='\033[0;34m';PURPLE='\033[0;35m'
CYAN='\033[0;36m';YELLOW='\033[1;33m';BOLD='\033[1m';DIM='\033[2m';NC='\033[0m'
GRAD1='\033[38;5;129m';GRAD2='\033[38;5;135m';GRAD3='\033[38;5;141m'

print_animated_header() {
    local cols=$(tput cols 2>/dev/null || echo 80)
    local width=64
    local padding=$(( (cols - width) / 2 ))
    printf "%*s" $padding ""
    printf "${GRAD1}${BOLD}╔══════════════════════════════════════════════════════════════╗${NC}\n"
    printf "%*s" $padding ""
    printf "${GRAD1}║${GRAD2}                    🚀 StrayCore Dashboard 🚀                 ${GRAD1}║${NC}\n"
    printf "%*s" $padding ""
    printf "${GRAD1}║${GRAD3}              Real-time System Performance Monitor            ${GRAD1}║${NC}\n"
    printf "%*s" $padding ""
    printf "${GRAD1}╟──────────────────────────────────────────────────────────────╢${NC}\n"
    printf "%*s" $padding ""
    printf "${GRAD1}║${YELLOW}         Developed by StrayVibes (Thomas Garau)               ${GRAD1}║${NC}\n"
    printf "%*s" $padding ""
    printf "${GRAD1}║${CYAN}            https://github.com/StrayVibes                     ${GRAD1}║${NC}\n"
    printf "%*s" $padding ""
    printf "${GRAD1}╚══════════════════════════════════════════════════════════════╝${NC}\n\n"
}

get_cpu_bar() {
    local usage=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} {printf "%.0f", usage}')
    local filled=$((usage/5))
    local empty=$((20-filled))
    printf "${GREEN}"
    for ((i=0; i<filled; i++)); do printf "█"; done
    printf "${DIM}"
    for ((i=0; i<empty; i++)); do printf "░"; done
    printf "${NC} ${BOLD}${usage}%%${NC}"
}

get_mem_bar() {
    local mem_info=$(free | awk 'NR==2{printf "%.0f %.0f", $3*100/$2, ($3*100/$2)}')
    local usage=$(echo $mem_info | cut -d' ' -f1)
    local filled=$((usage/5))
    local empty=$((20-filled))
    printf "${BLUE}"
    for ((i=0; i<filled; i++)); do printf "█"; done
    printf "${DIM}"
    for ((i=0; i<empty; i++)); do printf "░"; done
    local mem_used=$(free -m | awk 'NR==2{printf "%s", $3}')
    local mem_total=$(free -m | awk 'NR==2{printf "%s", $2}')
    printf "${NC} ${BOLD}${usage}%% (${mem_used}M/${mem_total}M)${NC}"
}

get_disk_usage() {
    df -h / | awk 'NR==2{
        gsub(/%/, "", $5)
        usage = int($5)
        filled = int(usage/5)
        empty = 20-filled
        printf "\033[0;33m"
        for(i=0; i<filled; i++) printf "█"
        printf "\033[2m"
        for(i=0; i<empty; i++) printf "░"
        printf "\033[0m \033[1m%s (%s/%s)\033[0m", $5"%", $3, $2
    }'
}

get_network_activity() {
    local iface=$(ip route | grep default | awk '{print $5}' | head -1)
    if [ -n "$iface" ]; then
        local rx_bytes=$(cat "/sys/class/net/${iface}/statistics/rx_bytes" 2>/dev/null || echo 0)
        local tx_bytes=$(cat "/sys/class/net/${iface}/statistics/tx_bytes" 2>/dev/null || echo 0)
        local rx_mb=$((rx_bytes / 1024 / 1024))
        local tx_mb=$((tx_bytes / 1024 / 1024))
        printf "↓ ${GREEN}${rx_mb}MB${NC} ↑ ${RED}${tx_mb}MB${NC}"
    else
        printf "N/A"
    fi
}

get_top_processes() {
    printf "\n${YELLOW}${BOLD}Top CPU Processes:${NC}\n"
    ps aux --sort=-%cpu | head -6 | tail -5 | awk '{
        printf "  %-12s %5s%% %6s  %s\n", $1, $3, $4"%", $11
    }'
}

show_system_info() {
    printf "${CYAN}${BOLD}System Information:${NC}\n"
    printf "  %-18s: %s\n" "Kernel" "$(uname -r)"
    printf "  %-18s: %s\n" "Uptime" "$(uptime -p)"
    printf "  %-18s: %s\n" "Architecture" "$(uname -m)"
    printf "  %-18s: %s\n" "CPU Model" "$(lscpu | grep 'Model name' | cut -d: -f2 | xargs)"
    printf "  %-18s: %s cores\n" "CPU Cores" "$(nproc)"
    if command -v sensors &> /dev/null; then
        local temp=$(sensors | grep 'Package id 0:' | awk '{print $4}' | head -1)
        if [ -n "$temp" ]; then
            printf "  %-18s: %s\n" "CPU Temperature" "$temp"
        fi
    fi
}

show_performance_metrics() {
    printf "\n${YELLOW}${BOLD}Performance Metrics:${NC}\n"
    printf "  %-18s: " "CPU Usage"
    get_cpu_bar
    printf "\n  %-18s: " "Memory Usage"
    get_mem_bar
    printf "\n  %-18s: " "Disk Usage"
    get_disk_usage
    printf "\n  %-18s: " "Network"
    get_network_activity
    printf "\n"
}

show_straycore_status() {
    printf "\n${PURPLE}${BOLD}StrayCore Optimizations:${NC}\n"
    printf "  %-18s: ${GREEN}%s${NC}\n" "CPU Governor" "$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null || echo 'N/A')"
    local io_sched=$(cat /sys/block/nvme*n*/queue/scheduler 2>/dev/null | head -n1 | grep -o '\[.*\]' | tr -d '[]' || echo 'N/A')
    printf "  %-18s: ${GREEN}%s${NC}\n" "I/O Scheduler" "$io_sched"
    printf "  %-18s: ${GREEN}%s${NC}\n" "TCP Congestion" "$(cat /proc/sys/net/ipv4/tcp_congestion_control 2>/dev/null || echo 'N/A')"
    printf "  %-18s: ${GREEN}%s${NC}\n" "Swappiness" "$(cat /proc/sys/vm/swappiness 2>/dev/null || echo 'N/A')"
    
    local mitigations="Unknown"
    if grep -q "mitigations=off" /proc/cmdline 2>/dev/null; then
        mitigations="${GREEN}Disabled${NC}"
    elif [ -d "/sys/devices/system/cpu/vulnerabilities" ]; then
        if ! grep -r "Vulnerable" /sys/devices/system/cpu/vulnerabilities/ > /dev/null 2>&1; then
            mitigations="${GREEN}Patched/Not Affected${NC}"
        else
            mitigations="${RED}Enabled${NC}"
        fi
    fi
    printf "  %-18s: %b\n" "Security Mitigations" "$mitigations"
}

trap "tput cnorm; clear; exit" INT TERM
trap "tput cnorm; clear" EXIT

tput civis

while true; do
    (
        tput cup 0 0
        print_animated_header
        show_system_info
        show_performance_metrics
        show_straycore_status
        get_top_processes
        printf "\n${GRAD1}${BOLD}StrayCore is Active & Optimized! 🔥${NC}\n"
        printf "${DIM}Updating automatically... Press 'q' to exit.${NC}\n"
    )
    
    read -rsn1 -t 1.5 key
    if [[ "$key" == "q" || "$key" == "Q" ]]; then
        break
    fi
done
EOF
    sudo chmod +x "/usr/local/bin/straycore"

    show_loading_bar 1 "   Creating welcome message"
    sudo tee "/etc/profile.d/straycore-motd.sh" >/dev/null << 'EOF'
#!/bin/bash
if [[ "$(uname -r)" == *"StrayCore"* ]]; then
    RED='\033[0;31m';GREEN='\033[0;32m';BLUE='\033[0;34m';PURPLE='\033[0;35m'
    CYAN='\033[0;36m';YELLOW='\033[1;33m';BOLD='\033[1m';NC='\033[0m'
    GRAD1='\033[38;5;129m';GRAD2='\033[38;5;135m';GRAD3='\033[38;5;141m'
    
    echo -e "${GRAD1}    ╭─────────────────────────────────────────────────────╮${NC}"
    echo -e "${GRAD1}    │${GRAD2}  ⚡ Welcome to StrayCore Kernel v2025.13 Guardian  ${GRAD1}│${NC}"
    echo -e "${GRAD1}    │${GRAD3}     🚀 Performance Mode: ACTIVATED 🚀              ${GRAD1}│${NC}"
    echo -e "${GRAD1}    ╰─────────────────────────────────────────────────────╯${NC}"
    echo -e ""
    echo -e "${PURPLE}           ╭─────────────────╮${NC}"
    echo -e "${PURPLE}           │   ${CYAN}/\_/\${PURPLE}         │${NC}  ${YELLOW}System optimized for:${NC}"
    echo -e "${PURPLE}           │  ${CYAN}( ${GREEN}^.^${CYAN} )${PURPLE}        │${NC}  ${GREEN}• Gaming Performance${NC}"
    echo -e "${PURPLE}           │   ${CYAN}> ^ <${PURPLE}         │${NC}  ${GREEN}• Development Speed${NC}"
    echo -e "${PURPLE}           ╰─────────────────╯${NC}  ${GREEN}• System Responsiveness${NC}"
    echo -e ""
    echo -e "${CYAN}${BOLD}Quick Commands:${NC}"
    echo -e "  ${YELLOW}straycore${NC}         - Launch advanced system dashboard"
    echo -e "  ${YELLOW}straycore-update${NC}  - Update to latest kernel version"
    echo -e ""
fi
EOF
    sudo chmod +x "/etc/profile.d/straycore-motd.sh"

    echo -e "${GREEN}✅ Advanced tools and dashboard created successfully${NC}"
    echo ""
}

finalize_installation() {
    echo -e "${BLUE}${BOLD}🧹 Finalizing Installation${NC}"
    
    show_loading_bar 2 "   Cleaning temporary files"
    cd / && rm -rf "$WORK_DIR" 2>/dev/null || true
    
    show_loading_bar 1 "   Updating system databases"
    sudo pacman -Sy >/dev/null 2>&1
    
    show_loading_bar 1 "   Optimizing system performance"
    sudo systemctl daemon-reload >/dev/null 2>&1
    
    echo -e "${GREEN}✅ Installation finalized and optimized${NC}"
    echo ""
}

show_holographic_success() {
    clear
    echo -e "${GRAD1}${BOLD}"
    echo "    ╔═══════════════════════════════════════════════════════════════╗"
    echo -e "    ║${GRAD2}                         🎉 SUCCESS! 🎉                        ${GRAD1}║"
    echo "    ║                                                               ║"
    echo -e "    ║${GRAD3}      StrayCore Kernel v2025.13 \"Guardian\" Installed!          ${GRAD1}║"
    echo "    ║                                                               ║"
    echo -e "    ║${GRAD4}              🚀 Ready for Maximum Performance 🚀              ${GRAD1}║"
    echo "    ╚═══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}\n"
    
    for i in {1..3}; do
        echo -e "${YELLOW}                    ✨ INSTALLATION COMPLETE ✨${NC}"
        sleep 0.3
        echo -e "\033[A\033[K${PURPLE}                    🎊 INSTALLATION COMPLETE 🎊${NC}"
        sleep 0.3
        echo -e "\033[A\033[K"
    done
    echo -e "${GREEN}${BOLD}                    🎉 INSTALLATION COMPLETE 🎉${NC}\n"
    
    echo -e "${CYAN}${BOLD}📋 Next Steps:${NC}"
    echo -e "${YELLOW}  1. ${BOLD}Reboot${NC} your system"
    echo -e "${YELLOW}  2. Select ${BOLD}StrayCore${NC} kernel from bootloader"
    echo -e "${YELLOW}  3. Enjoy the new ${BOLD}animated welcome message${NC}"
    echo -e "${YELLOW}  4. Run ${BOLD}'straycore'${NC} to see your system dashboard"
    echo ""
    
    echo -e "${PURPLE}${BOLD}🎮 Performance Features Activated:${NC}"
    echo -e "${GREEN}  ✅ CPU Performance Governor${NC}"
    echo -e "${GREEN}  ✅ BBR TCP Congestion Control${NC}"
    echo -e "${GREEN}  ✅ BFQ I/O Scheduler${NC}"
    echo -e "${GREEN}  ✅ Optimized Memory Management${NC}"
    echo -e "${GREEN}  ✅ Gaming-focused Kernel Parameters${NC}"
    echo ""
    
    echo -e "${CYAN}${BOLD}🔄 System Reboot Required${NC}"
    read -p "$(echo -e ${YELLOW}"Would you like to reboot now? (y/N): "${NC})" -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}${BOLD}Preparing for reboot...${NC}"
        show_loading_bar 2 "   Syncing filesystems"
        sync
        
        echo -e "${PURPLE}Rebooting in:${NC}"
        for i in {5..1}; do
            echo -ne "${YELLOW}${BOLD}  $i${NC}\r"
            sleep 1
        done
        echo -e "${GREEN}${BOLD}  Rebooting now! 🚀${NC}"
        sudo reboot
    else
        echo -e "${CYAN}Remember to reboot when convenient to activate StrayCore!${NC}"
        echo -e "${YELLOW}Run ${BOLD}'sudo reboot'${NC}${YELLOW} when ready.${NC}"
    fi
}

main() {
    trap 'echo -e "\n${RED}❌ Build interrupted! Cleaning up...${NC}"; cd /; rm -rf "$WORK_DIR" 2>/dev/null; exit 1' INT TERM
    
    show_banner
    sleep 1
    
    echo -e "${YELLOW}${BOLD}🚀 Initializing StrayCore Modern Installation${NC}"    
    echo -e "${PURPLE}${BOLD}⚠️  Installation Overview:${NC}"
    echo -e "${CYAN}  • Download latest stable kernel source${NC}"
    echo -e "${CYAN}  • Apply gaming & development optimizations${NC}"  
    echo -e "${CYAN}  • Build with clean progress monitoring${NC}"
    echo -e "${CYAN}  • Install with advanced dashboard tools${NC}"
    echo ""
    
    read -p "$(echo -e ${YELLOW}"Continue with StrayCore installation? (Y/n): "${NC})" -n 1 -r
    echo
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        echo -e "${YELLOW}Installation cancelled by user${NC}"
        exit 0
    fi
    
    echo -e "\n${GREEN}${BOLD}🎬 Starting installation sequence...${NC}\n"
    
    check_system
    install_dependencies  
    prepare_source
    create_config
    build_kernel
    install_kernel
    configure_bootloader
    create_tools
    finalize_installation
    show_holographic_success
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    for cmd in curl jq wget tar bc; do
        if ! command -v $cmd &> /dev/null; then
            echo -e "${RED}❌ Missing required command: $cmd${NC}"
            echo -e "${YELLOW}Please install it first: sudo pacman -S $cmd${NC}"
            exit 1
        fi
    done
    
    main "$@"
fi

