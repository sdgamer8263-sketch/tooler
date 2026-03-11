#!/bin/bash

# ==================================================
#  VPS MASTER PANEL v5.0 | AUTO-DETECT DASHBOARD
# ==================================================

# --- ROOT CHECK ---
if [[ $EUID -ne 0 ]]; then
   echo -e "\e[31m❌ This script must be run as root. Please run with sudo.\e[0m"
   exit 1
fi

# --- COLORS ---
R="\e[31m"; G="\e[32m"; Y="\e[33m"; B="\e[34m"; C="\e[36m"; M="\e[35m"; W="\e[37m"; N="\e[0m"
BOLD="\e[1m"

# --- AUTO-DETECT VARIABLES ---
detect_system() {
    # 1. IP Address
    PUBLIC_IP=$(curl -s --max-time 2 ifconfig.me || hostname -I | awk '{print $1}')
    
    # 2. OS Info
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS_NAME=$PRETTY_NAME
    else
        OS_NAME=$(uname -s)
    fi
    
    # 3. Resources (More robust CPU check)
    if [ -f /proc/loadavg ]; then
        CPU_LOAD=$(awk '{print $1}' /proc/loadavg)
    else
        CPU_LOAD=$(uptime | rev | cut -d: -f1 | rev | xargs)
    fi
    
    RAM_USED=$(free -h | awk '/^Mem:/ {print $3 "/" $2}')
    DISK_USED=$(df -h / | awk 'NR==2 {print $3 "/" $2 " (" $5 ")"}')
}

# --- SERVICE STATUS CHECKER ---
check_status() {
    local service=$1
    if systemctl is-active --quiet "$service"; then
        echo -e "${G}● RUNNING${N}"
    elif command -v "$service" &>/dev/null; then
        echo -e "${R}● STOPPED${N}"
    else
        echo -e "${W}○ NOT INSTALLED${N}"
    fi
}

check_lxc() {
    if systemctl is-active --quiet lxd || systemctl is-active --quiet snap.lxd.daemon; then
        local count=$(lxc list --format csv 2>/dev/null | wc -l | tr -d ' ')
        echo -e "${G}● ACTIVE ($count Containers)${N}"
    elif command -v lxc &>/dev/null; then
        echo -e "${R}● STOPPED${N}"
    else
        echo -e "${W}○ NOT INSTALLED${N}"
    fi
}

check_docker() {
    if systemctl is-active --quiet docker; then
        local count=$(docker ps -q 2>/dev/null | wc -l | tr -d ' ')
        echo -e "${G}● ACTIVE ($count Running)${N}"
    elif command -v docker &>/dev/null; then
        echo -e "${R}● STOPPED${N}"
    else
        echo -e "${W}○ NOT INSTALLED${N}"
    fi
}

# --- MAIN DASHBOARD HEADER ---
draw_header() {
    detect_system
    clear
    echo -e "${B}╔══════════════════════════════════════════════════════════════╗${N}"
    echo -e "${B}║${W}${BOLD}              🚀 VPS MASTER PANEL v5.0 (Auto-Detect)          ${B}║${N}"
    echo -e "${B}╠══════════════════════════════════════════════════════════════╣${N}"
    echo -e "${B}║${C} SYSTEM INFO:${N}                                                 ${B}║${N}"
    echo -e "${B}║${W} • OS       :${N} ${Y}$OS_NAME${N}"
    echo -e "${B}║${W} • IP Addr  :${N} ${Y}$PUBLIC_IP${N}"
    echo -e "${B}║${W} • CPU Load :${N} $CPU_LOAD"
    echo -e "${B}║${W} • RAM Usage:${N} $RAM_USED"
    echo -e "${B}║${W} • Disk Use :${N} $DISK_USED"
    echo -e "${B}╠══════════════════════════════════════════════════════════════╣${N}"
    echo -e "${B}║${M} SERVICE STATUS:${N}                                              ${B}║${N}"
    echo -e "${B}║${W} • Docker   :${N} $(check_docker)"
    echo -e "${B}║${W} • LXC/LXD  :${N} $(check_lxc)"
    echo -e "${B}║${W} • Host RDP :${N} $(check_status xrdp)"
    echo -e "${B}╚══════════════════════════════════════════════════════════════╝${N}"
    echo
}

pause() { echo; read -p "↩ Press Enter..." _; }

# ==================================================
#  1. DOCKER MANAGER
# ==================================================
docker_menu() {
    while true; do
        draw_header
        echo -e "${C}🐳 DOCKER MANAGER${N}"
        echo "--------------------------------"
        echo "1) List Containers"
        echo "2) Install Docker"
        echo "3) Deploy Portainer (GUI)"
        echo "4) Deploy Nginx Proxy Manager"
        echo "0) Back"
        echo
        read -p "Select: " opt
        case $opt in
            1) docker ps -a; pause ;;
            2) curl -fsSL https://get.docker.com | sh; systemctl enable --now docker; pause ;;
            3) docker run -d -p 9000:9000 -p 8000:8000 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer-ce:latest; echo "Portainer on port 9000"; pause ;;
            4) docker run -d -p 81:81 -p 80:80 -p 443:443 --name npm --restart=always jc21/nginx-proxy-manager:latest; echo "NPM on port 81"; pause ;;
            0) return ;;
        esac
    done
}

# ==================================================
#  2. LXC/KVM MANAGER
# ==================================================
lxc_menu() {
    while true; do
        draw_header
        echo -e "${M}📦 LXC/LXD MANAGER (VPS Containers)${N}"
        echo "--------------------------------"
        echo "1) List VPS Containers"
        echo "2) Create New VPS (Normal)"
        echo "3) Create VPS + Desktop (RDP)"
        echo "4) Delete VPS"
        echo "5) Install LXD"
        echo "0) Back"
        echo
        read -p "Select: " opt
        case $opt in
            1) lxc list; pause ;;
            2) 
                read -p "Name: " n
                lxc launch ubuntu:22.04 "$n"
                echo "Created."; pause 
                ;;
            3)
                read -p "Name: " n
                echo -e "${Y}Creating Container & Waiting for Network...${N}"
                lxc launch ubuntu:22.04 "$n"
                sleep 8 # Wait for IPv4 address to be assigned
                
                echo -e "${Y}Installing Desktop (This will take a few minutes)...${N}"
                lxc exec "$n" -- env DEBIAN_FRONTEND=noninteractive apt update
                lxc exec "$n" -- env DEBIAN_FRONTEND=noninteractive apt install -y xfce4 xfce4-goodies xrdp dbus-x11
                
                lxc exec "$n" -- adduser xrdp ssl-cert
                lxc exec "$n" -- sh -c "echo 'xfce4-session' > /root/.xsession"
                lxc exec "$n" -- systemctl restart xrdp
                lxc exec "$n" -- sh -c "echo 'ubuntu:root' | chpasswd"
                
                echo -e "${G}Done! Connect via RDP. User: ubuntu | Pass: root${N}"; pause
                ;;
            4) read -p "Name: " n; lxc delete "$n" --force; pause ;;
            5) apt update && env DEBIAN_FRONTEND=noninteractive apt install -y snapd; snap install lxd; lxd init --auto; pause ;;
            0) return ;;
        esac
    done
}

# ==================================================
#  3. HOST RDP MANAGER
# ==================================================
rdp_menu() {
    while true; do
        draw_header
        echo -e "${G}🖥️  HOST DESKTOP MANAGER${N}"
        echo "--------------------------------"
        echo "1) Install XFCE Desktop + RDP"
        echo "2) Install Chrome Browser"
        echo "3) Create RDP User"
        echo "4) Start/Restart RDP"
        echo "0) Back"
        echo
        read -p "Select: " opt
        case $opt in
            1) 
                env DEBIAN_FRONTEND=noninteractive apt update
                env DEBIAN_FRONTEND=noninteractive apt install -y xfce4 xfce4-goodies xrdp
                systemctl enable xrdp
                echo "xfce4-session" > /root/.xsession
                echo -e "${G}Installation Complete.${N}"; pause 
                ;;
            2) 
                wget -q -O /tmp/chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
                env DEBIAN_FRONTEND=noninteractive apt install -y /tmp/chrome.deb
                sed -i 's|Exec=/usr/bin/google-chrome-stable|Exec=/usr/bin/google-chrome-stable --no-sandbox|g' /usr/share/applications/google-chrome.desktop
                rm -f /tmp/chrome.deb
                echo -e "${G}Chrome Installed.${N}"; pause 
                ;;
            3) 
                read -p "User: " u
                read -s -p "Pass: " p; echo
                useradd -m -s /bin/bash "$u"
                echo "$u:$p" | chpasswd
                echo "xfce4-session" > /home/$u/.xsession
                chown "$u:$u" /home/$u/.xsession # Fix permissions issue
                echo -e "${G}Done. User '$u' created.${N}"; pause 
                ;;
            4) 
                systemctl restart xrdp
                echo "Restarted."; pause 
                ;;
            0) return ;;
        esac
    done
}

# ==================================================
#  MAIN LOOP
# ==================================================
while true; do
    draw_header
    echo -e " ${C}[1]${N} Docker Manager       ${Y}(Apps & Containers)"
    echo -e " ${M}[2]${N} LXC/LXD Manager      ${Y}(Virtual VPS)"
    echo -e " ${G}[3]${N} Host RDP Manager     ${Y}(Install GUI on Host)"
    echo -e " ${R}[0]${N} Exit"
    echo
    read -p " ➤ Choose Option: " main_opt
    
    case $main_opt in
        1) docker_menu ;;
        2) lxc_menu ;;
        3) rdp_menu ;;
        0) clear; exit 0 ;;
        *) ;;
    esac
done

