#!/bin/bash

# ==========================================
# SDGAMER TOOLS PANEL
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

# Function for 3D Blocky Banner (Main Menu)
banner() {
    clear
    echo -e "${C} ▬▬▬ ${W}HOST: ${C}SDGAMER  ${W}│ ${C}TOOLS PANEL ${W}│ ${C}STATUS: ACTIVE ${C}▬▬▬${NC}"
    echo -e "${B}  ██████  ██████   ██████   █████  ███    ███ ███████ ██████  ${NC}"
    echo -e "${P} ██      ██   ██ ██       ██   ██ ████  ████ ██      ██   ██ ${NC}"
    echo -e "${C}  █████  ██   ██ ██   ███ ███████ ██ ████ ██ █████   ██████  ${NC}"
    echo -e "${G}      ██ ██   ██ ██    ██ ██   ██ ██  ██  ██ ██      ██   ██ ${NC}"
    echo -e "${Y} ██████  ██████   ██████  ██   ██ ██      ██ ███████ ██   ██ ${NC}"
    echo -e "${W} ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬${NC}"
    echo -e " ${G}● ${W}System Health: ${G}CONNECTED ${W}│ ${Y}SECURE: YES ${W}│ ${B}NET: STABLE${NC}"
    echo ""
}

# Function for 3D Blocky Banner (RDP Submenu)
rdp_banner() {
    clear
    echo -e "${G}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${C}   ██████  ██████  ██████  ${NC}"
    echo -e "${C}   ██   ██ ██   ██ ██   ██ ${NC}"
    echo -e "${C}   ██████  ██   ██ ██████  ${NC}"
    echo -e "${C}   ██   ██ ██   ██ ██      ${NC}"
    echo -e "${C}   ██   ██ ██████  ██      ${NC}"
    echo -e "${G}╚══════════════════════════════════════════════════════════╝${NC}"
    echo -e "             ${Y}⚡ REMOTE DESKTOP DEPLOYMENT ⚡${NC}"
    echo ""
}

# RDP Submenu Loop
show_rdp_menu() {
    while true; do
        rdp_banner
        echo -e "    ${C}➥${W} [A] Install Ubuntu OS"
        echo -e "    ${C}➥${W} [B] Install Debian OS"
        echo -e "    ${C}➥${W} [C] Return to Main Menu"
        echo ""
        echo -en "${G} ⚡ Select OS [A/B/C]: ${NC}"
        read -r rdp_choice

        case "$rdp_choice" in
            [Aa]) 
                curl -fsSL https://raw.githubusercontent.com/sdgamer8263-sketch/Rdp/main/install.sh | sudo bash 
                echo -e "\n${G}✔ Task Finished!${NC}"
                echo -en "${W}Press ${Y}[ENTER]${W} to return to RDP Menu...${NC}"
                read -r
                ;;
            [Bb]) 
                curl -fsSL https://raw.githubusercontent.com/sdgamer8263-sketch/rdp2/main/install.sh | sudo bash 
                echo -e "\n${G}✔ Task Finished!${NC}"
                echo -en "${W}Press ${Y}[ENTER]${W} to return to RDP Menu...${NC}"
                read -r
                ;;
            [Cc]) 
                break 
                ;;
            *) 
                echo -e "${R}Invalid Input! Please try again...${NC}"
                sleep 1 
                ;;
        esac
    done
}

# Main Application Loop
while true; do
    banner
    echo -e " ${B}▩ AVAILABLE TOOLS & SERVICES${NC}"
    echo -e " ${C}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "      ${G}[1]${W} Cloudflare                 ||    ${G}[8]${W} SSHX"
    echo -e "      ${G}[2]${W} Tailscale                  ||    ${G}[9]${W} IP Check"
    echo -e "      ${G}[3]${W} Root Access                ||   ${G}[10]${W} Zerotier"
    echo -e "      ${G}[4]${W} Terminal                   ||   ${G}[11]${W} Docker"
    echo -e "      ${G}[5]${W} System                     ||   ${G}[12]${W} Telebit"
    echo -e "      ${G}[6]${W} RDP + noVNC                ||   ${G}[13]${W} Firewall"
    echo -e "      ${G}[7]${W} Only RDP (Ubuntu/Debian)   ||    ${R}[0]${W} EXIT SCRIPT"
    echo -e " ${C}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -en "${Y} ⚡ Select Option [0-13]: ${NC}"
    read -r main_choice

    case "$main_choice" in
        1|01) bash <(curl -sL https://raw.githubusercontent.com/sdgamer8263-sketch/tooler/main/cloudflare.sh) ;;
        2|02) bash <(curl -sL https://raw.githubusercontent.com/sdgamer8263-sketch/tooler/main/Tailscale.sh) ;;
        3|03) bash <(curl -sL https://raw.githubusercontent.com/sdgamer8263-sketch/tooler/main/root.sh) ;;
        4|04) bash <(curl -sL https://raw.githubusercontent.com/sdgamer8263-sketch/tooler/main/terminal.sh) ;;
        5|05) bash <(curl -sL https://raw.githubusercontent.com/sdgamer8263-sketch/tooler/main/SYSTEM.sh) ;;
        6|06) bash <(curl -s https://raw.githubusercontent.com/nobita329/The-Coding-Hub/refs/heads/main/srv/tools/rdp.sh) ;;
        7|07) show_rdp_menu; continue ;; # Continues main loop so it doesn't prompt "Task Finished" twice
        8|08) curl -sSf https://sshx.io/get | sh -s run ;;
        9|09) 
            echo -e "\n${C}Fetching Public IP...${NC}"
            curl -4 icanhazip.com 
            ;;
        10) bash <(curl -sL https://raw.githubusercontent.com/sdgamer8263-sketch/tooler/main/zerotier.sh) ;;
        11) bash <(curl -sL https://raw.githubusercontent.com/sdgamer8263-sketch/tooler/main/Docker.sh) ;;
        12) bash <(curl -sL https://raw.githubusercontent.com/sdgamer8263-sketch/tooler/main/telebit.sh) ;;
        13) bash <(curl -sL https://raw.githubusercontent.com/sdgamer8263-sketch/tooler/main/firewall.sh) ;;
        0|00) echo -e "\n${Y}Closing SDGAMER Tools Panel...${NC}"; exit 0 ;;
        *) echo -e "${R}Invalid Option!${NC}"; sleep 1; continue ;;
    esac

    echo -e "\n${G}✔ Task Finished!${NC}"
    echo -en "${W}Press ${Y}[ENTER]${W} to return to Main Menu...${NC}"
    read -r
done

