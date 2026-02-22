#!/bin/bash

# Function to show the main menu with SDGAMER Banner
show_menu() {
    clear
    echo -e "\e[1;32m"
    echo "  ____  ____   ____    _    __  __ _____ ____  "
    echo " / ___||  _ \ / ___|  / \  |  \/  | ____|  _ \ "
    echo " \___ \| | | | |  _  / _ \ | |\/| |  _| | |_) |"
    echo "  ___) | |_| | |_| |/ ___ \| |  | | |___|  _ < "
    echo " |____/|____/ \____/_/   \_\_|  |_|_____|_| \_\\"
    echo -e "\e[0m"
    echo "==============================================="
    echo "       WELCOME TO SDGAMER TOOLS PANEL          "
    echo "==============================================="
    echo "1. Cloudflare"
    echo "2. Tailscale"
    echo "3. Root Access"
    echo "4. Terminal"
    echo "5. System"
    echo "6. RDP + noVNC"
    echo "7. Only RDP (Ubuntu/Debian)"
    echo "8. SSHX"
    echo "9. IP Check"
    echo "10.Zerotier"
    echo "11.Docker"
    echo "0. Exit"
    echo "==============================================="
    read -p "Select an option [0-9]: " main_choice

    case $main_choice in
        1) bash <(curl -sL https://raw.githubusercontent.com/sdgamer8263-sketch/tooler/main/cloudflare.sh) ;;
        2) bash <(curl -sL https://raw.githubusercontent.com/sdgamer8263-sketch/tooler/main/Tailscale.sh) ;;
        3) bash <(curl -sL https://raw.githubusercontent.com/sdgamer8263-sketch/tooler/main/root.sh) ;;
        4) bash <(curl -sL https://raw.githubusercontent.com/sdgamer8263-sketch/tooler/main/terminal.sh) ;;
        5) bash <(curl -sL https://raw.githubusercontent.com/sdgamer8263-sketch/tooler/main/SYSTEM.sh) ;;
        6) bash <(curl -sL https://raw.githubusercontent.com/sdgamer8263-sketch/tooler/main/rdp.sh) ;;
        7) show_rdp_menu ;;
        8) curl -sSf https://sshx.io/get | sh -s run ;;
        9) curl -4 icanhazip.com ;;
        10)bash <(curl -sL https://raw.githubusercontent.com/sdgamer8263-sketch/tooler/main/zerotier.sh) ;;
        11)bash <(curl -sL https://raw.githubusercontent.com/sdgamer8263-sketch/tooler/main/Docker.sh) ;;

        0) exit 0 ;;
        *) echo -e "\e[1;31m\nInvalid Option!\e[0m"; sleep 2; show_menu ;;
    esac

    # Option 7 chara baki sob gular por Enter chibe
    if [ "$main_choice" != "7" ]; then
        echo -e "\n\e[1;33mTask Finished.\e[0m"
        read -p "Press Enter to go back to Main Menu..."
        show_menu
    fi
}

# Function for Option 7 (Only RDP Sub-menu)
show_rdp_menu() {
    clear
    echo -e "\e[1;36m"
    echo "  ____  ____  ____    ____  _   _ _____ "
    echo " |  _ \|  _ \|  _ \  |  _ \| \ | | ____|"
    echo " | |_) | | | | |_) | | |_) |  \| |  _|  "
    echo " |  _ <| |_| |  __/  |  __/| |\  | |___ "
    echo " |_| \_\____/|_|     |_|   |_| \_|_____|"
    echo -e "\e[0m"
    echo "==============================================="
    echo "            ONLY RDP OPTIONS                   "
    echo "==============================================="
    echo "A) Ubuntu OS"
    echo "B) Debian OS"
    echo "C) Back to Main Menu"
    echo "==============================================="
    read -p "Select OS [A/B] or C to go back: " rdp_choice

    case $rdp_choice in
        [Aa]) 
            curl -fsSL https://raw.githubusercontent.com/sdgamer8263-sketch/Rdp/main/install.sh | sudo bash 
            echo -e "\n\e[1;33mTask Finished.\e[0m"
            read -p "Press Enter to go back to RDP Menu..."
            show_rdp_menu
            ;;
        [Bb]) 
            curl -fsSL https://raw.githubusercontent.com/sdgamer8263-sketch/rdp2/main/install.sh | sudo bash 
            echo -e "\n\e[1;33mTask Finished.\e[0m"
            read -p "Press Enter to go back to RDP Menu..."
            show_rdp_menu
            ;;
        [Cc]) 
            show_menu 
            ;;
        *) 
            echo -e "\e[1;31m\nInvalid Input! Please try again...\e[0m"
            sleep 2
            show_rdp_menu 
            ;;
    esac
}

# Start the script
show_menu
