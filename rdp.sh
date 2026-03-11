#!/bin/bash

# ==========================================
# SDGAMER RDP + noVNC CONTROL PANEL
# STYLE: 3D SHADOW BLOCKY
# ==========================================

# Colors
R='\033[1;31m'
G='\033[1;32m'
Y='\033[1;33m'
B='\033[1;34m'
P='\033[1;35m'
C='\033[1;36m'
W='\033[1;37m'
NC='\033[0m'

# Check root
if [ "$EUID" -ne 0 ]; then
    echo -e "${R}Please run as root: sudo bash $0${NC}"
    exit 1
fi

banner() {
    clear
    echo -e "${C} ▬▬▬ ${W}HOST: ${C}SDGAMER  ${W}│ ${C}RDP & noVNC PANEL ${C}▬▬▬${NC}"
    echo -e "${B}  ██████  ██████   ██████   █████  ███    ███ ███████ ██████  ${NC}"
    echo -e "${P} ██      ██   ██ ██       ██   ██ ████  ████ ██      ██   ██ ${NC}"
    echo -e "${C}  █████  ██   ██ ██   ███ ███████ ██ ████ ██ █████   ██████  ${NC}"
    echo -e "${G}      ██ ██   ██ ██    ██ ██   ██ ██  ██  ██ ██      ██   ██ ${NC}"
    echo -e "${Y} ██████  ██████   ██████  ██   ██ ██      ██ ███████ ██   ██ ${NC}"
    echo -e "${W} ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬${NC}"
    echo ""
}

show_info() {
    IP=$(curl -s ifconfig.me || hostname -I | awk '{print $1}')
    echo -e "${C}════════════════════════════════════════════${NC}"
    echo -e "${Y}🔗 Connection Info:${NC}"
    echo -e "${G}RDP   :${W} $IP:3389${NC}"
    echo -e "${G}noVNC :${W} http://$IP:6080/vnc.html${NC}"
    echo -e "${G}VNC   :${W} $IP:5901${NC}"
    echo -e "${C}════════════════════════════════════════════${NC}"
    echo ""
}

# --- WORKING COMMANDS ---

install_all() {
    echo -e "${Y}📦 Installing Desktop (XFCE) + RDP + noVNC...${NC}"
    
    # Update and Install
    apt update -y
    apt install -y xfce4 xfce4-goodies xfce4-terminal xrdp tigervnc-standalone-server tigervnc-common novnc websockify ssl-cert
    
    # Configure xRDP
    systemctl enable xrdp
    adduser xrdp ssl-cert
    echo "xfce4-session" > ~/.xsession
    echo "xfce4-session" > /etc/skel/.xsession
    chmod +x ~/.xsession
    
    # VNC Setup
    mkdir -p ~/.vnc
    echo -e "${C}Please set a password for VNC/noVNC:${NC}"
    vncpasswd
    
    cat > ~/.vnc/config <<EOF
geometry=1280x720
depth=24
localhost
alwaysshared
EOF
    
    # Start VNC
    vncserver -kill :1 2>/dev/null || true
    vncserver -localhost no :1
    
    # noVNC Service
    cat > /etc/systemd/system/novnc.service <<EOF
[Unit]
Description=noVNC Server
After=network.target

[Service]
Type=simple
User=root
ExecStart=/usr/bin/websockify --web=/usr/share/novnc/ 6080 localhost:5901
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
    
    systemctl daemon-reload
    systemctl enable novnc
    systemctl start novnc
    systemctl restart xrdp
    
    # Firewall
    ufw allow 3389/tcp >/dev/null 2>&1 || true
    ufw allow 6080/tcp >/dev/null 2>&1 || true
    ufw allow 5901/tcp >/dev/null 2>&1 || true
    
    echo -e "${G}✅ RDP & noVNC Installed Successfully!${NC}"
}

start_services() {
    echo -e "${Y}▶ Starting Services (Useful after VPS restart)...${NC}"
    systemctl start xrdp
    vncserver -localhost no :1 2>/dev/null || echo -e "${C}VNC is already running.${NC}"
    systemctl start novnc
    echo -e "${G}✅ Services Started!${NC}"
}

stop_services() {
    echo -e "${Y}⏹ Stopping Services...${NC}"
    systemctl stop xrdp
    systemctl stop novnc
    vncserver -kill :1 2>/dev/null || true
    echo -e "${G}✅ Services Stopped!${NC}"
}

status_services() {
    systemctl is-active --quiet xrdp && echo -e "xRDP    : ${G}ACTIVE${NC}" || echo -e "xRDP    : ${R}INACTIVE${NC}"
    systemctl is-active --quiet novnc && echo -e "noVNC   : ${G}ACTIVE${NC}" || echo -e "noVNC   : ${R}INACTIVE${NC}"
    netstat -tulpn 2>/dev/null | grep -qE ":3389|:6080|:5901" && echo -e "Ports   : ${G}LISTENING${NC}" || echo -e "Ports   : ${R}NOT LISTENING${NC}"
}

add_user() {
    echo -e "${Y}👤 Create a new user for RDP access${NC}"
    read -p "Enter new username: " new_user
    if id "$new_user" &>/dev/null; then
        echo -e "${R}User $new_user already exists!${NC}"
    else
        adduser "$new_user"
        usermod -aG sudo "$new_user"
        echo "xfce4-session" > /home/$new_user/.xsession
        chown $new_user:$new_user /home/$new_user/.xsession
        echo -e "${G}✅ User $new_user created successfully! You can now login to RDP with this user.${NC}"
    fi
}

install_browsers() {
    echo -e "${Y}🌐 Installing Browsers...${NC}"
    apt install -y firefox-esr chromium
    wget -q -O /tmp/chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    apt install -y /tmp/chrome.deb 2>/dev/null
    echo -e "${G}✅ Browsers Installed!${NC}"
}

# --- MAIN MENU LOOP ---
while true; do
    banner
    show_info
    
    echo -e "${C}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "  ${G}[1]${W} Install RDP + noVNC (Combined)"
    echo -e "  ${G}[2]${W} Start Services (After VPS Reboot)"
    echo -e "  ${G}[3]${W} Stop Services"
    echo -e "  ${G}[4]${W} Restart Services"
    echo -e "  ${G}[5]${W} Check Status"
    echo -e "  ${G}[6]${W} Change VNC Password"
    echo -e "  ${G}[7]${W} Install Browsers"
    echo -e "  ${G}[8]${W} Add New RDP User"
    echo -e "  ${R}[9]${W} Uninstall Everything"
    echo -e "  ${R}[0]${W} Exit"
    echo -e "${C}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -en "${Y} ⚡ Select Option: ${NC}"
    read -r opt
    
    echo ""
    case "$opt" in
        1) install_all ;;
        2) start_services ;;
        3) stop_services ;;
        4) stop_services; start_services ;;
        5) status_services ;;
        6) vncpasswd; vncserver -kill :1 2>/dev/null; vncserver -localhost no :1 ;;
        7) install_browsers ;;
        8) add_user ;;
        9) 
            echo -e "${R}Removing RDP and noVNC...${NC}"
            stop_services
            apt purge -y xfce4* xrdp tigervnc* novnc websockify
            rm -rf ~/.vnc /etc/xrdp /etc/systemd/system/novnc.service ~/.xsession
            systemctl daemon-reload
            apt autoremove -y
            echo -e "${G}✅ Uninstalled!${NC}"
            ;;
        0) echo -e "${G}Goodbye!${NC}"; exit 0 ;;
        *) echo -e "${R}Invalid option!${NC}" ;;
    esac
    
    echo ""
    echo -en "${W}Press ${Y}[ENTER]${W} to return to main menu...${NC}"
    read -r
done

