#!/bin/bash

# Colors for better look
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print the banner
print_banner() {
    clear
    echo -e "${CYAN}"
    echo "  ____  ____   ____ __  __ ______ ____  "
    echo " / ___||  _ \ / ___|  \/  |  ____|  _ \ "
    echo " \___ \| | | | |  _| |\/| | |__  | |_) |"
    echo "  ___) | |_| | |_| | |  | |  __| |  _ < "
    echo " |____/|____/ \____|_|  |_|______| | \_\ "
    echo -e "${NC}"
    echo -e "${YELLOW}       Telebit Installer by SDGMER${NC}"
    echo "----------------------------------------"
}

# Function to detect OS and install dependencies
install_dependencies() {
    echo -e "${YELLOW}[*] Detecting Operating System...${NC}"
    
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$ID
    else
        echo -e "${RED}Cannot detect OS. Exiting.${NC}"
        exit 1
    fi

    echo -e "${GREEN}[*] OS Detected: $OS${NC}"

    if [[ "$OS" == "ubuntu" || "$OS" == "debian" || "$OS" == "kali" || "$OS" == "linuxmint" ]]; then
        echo -e "${YELLOW}[*] Using APT package manager...${NC}"
        sudo apt update
        sudo apt install curl -y
    elif [[ "$OS" == "fedora" || "$OS" == "centos" || "$OS" == "rhel" ]]; then
        echo -e "${YELLOW}[*] Using DNF package manager...${NC}"
        sudo dnf install curl -y
    else
        echo -e "${RED}[!] OS not fully supported for auto-dependency, trying to proceed...${NC}"
    fi
}

# Function to install Telebit
install_telebit() {
    install_dependencies
    echo -e "${GREEN}[*] Installing Telebit...${NC}"
    
    # Official Telebit Install Command
    curl https://get.telebit.io/ | bash
    
    echo -e "${GREEN}[✔] Installation Complete!${NC}"
}

# Function to uninstall Telebit
uninstall_telebit() {
    echo -e "${RED}[*] Uninstalling Telebit...${NC}"
    
    # Stopping service and removing files
    if [ -d ~/telebit ]; then
        ~/telebit/telebit stop
        rm -rf ~/telebit
        
        # Removing systemd service if it exists
        if [ -f /etc/systemd/system/telebit.service ]; then
            sudo systemctl stop telebit
            sudo systemctl disable telebit
            sudo rm /etc/systemd/system/telebit.service
            sudo systemctl daemon-reload
        fi
        
        echo -e "${GREEN}[✔] Telebit has been uninstalled.${NC}"
    else
        echo -e "${RED}[!] Telebit directory not found. Is it installed?${NC}"
    fi
}

# Main Logic
print_banner
echo -e "${CYAN}1. Install Telebit${NC}"
echo -e "${CYAN}2. Uninstall Telebit${NC}"
echo "----------------------------------------"
read -p "Select an option (1/2): " choice

case $choice in
    1)
        install_telebit
        ;;
    2)
        uninstall_telebit
        ;;
    *)
        echo -e "${RED}Invalid Selection${NC}"
        ;;
esac

echo ""
echo "----------------------------------------"
# Waiting for Enter key as requested
read -p "Press Enter to continue..." temp
clear
