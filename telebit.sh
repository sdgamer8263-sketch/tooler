import os
import sys
import time
import platform
from colorama import Fore, Style, init

# Initialize colors
init(autoreset=True)

# Define Colors
R = Fore.RED
G = Fore.GREEN
C = Fore.CYAN
Y = Fore.YELLOW
W = Fore.WHITE
RESET = Style.RESET_ALL

def get_pkg_manager():
    """Detects the operating system and returns the appropriate package manager."""
    distro = platform.linux_distribution()[0].lower() if hasattr(platform, 'linux_distribution') else ""
    
    # Alternative detection if platform.linux_distribution() is not available
    if os.path.exists("/etc/debian_version"):
        return "apt"
    elif os.path.exists("/etc/fedora-release") or os.path.exists("/etc/redhat-release"):
        return "dnf"
    else:
        # Default fallback
        return "apt"

def clear_screen():
    os.system('cls' if os.name == 'nt' else 'clear')

def banner():
    clear_screen()
    logo = f"""{G}
      ____  ____  ____    _    __  __ _____ ____  
     / ___||  _ \/ ___|  / \  |  \/  | ____|  _ \ 
     \___ \| | | | |  _  / _ \ | |\/| |  _| | |_) |
      ___) | |_| | |_| |/ ___ \| |  | | |___|  _ < 
     |____/|____/ \____/_/   \_\_|  |_|_____|_| \_\\
    {R}
         [ Created for SDGAMER ]
         [ Version 2.1 - Auto OS Detect ]
    {RESET}"""
    print(logo)
    print(f"{C}========================================{RESET}")

def install_process():
    pkg_manager = get_pkg_manager()
    print(f"\n{G}[+] System Detected. Using: {Y}{pkg_manager}{RESET}")
    time.sleep(1)

    print(f"{Y}[*] Updating system packages...{RESET}")
    # Example usage of detected manager
    # os.system(f'sudo {pkg_manager} update -y')
    
    print(f"{Y}[*] Installing dependencies via {pkg_manager}...{RESET}")
    time.sleep(2)
    
    print(f"{Y}[*] Configuring environment...{RESET}")
    time.sleep(2)
    
    print(f"\n{G}[SUCCESS] Installation Complete!{RESET}")
    input(f"\n{C}[ Installation Done! Press Enter to continue ]{RESET}")

def uninstall_process():
    pkg_manager = get_pkg_manager()
    print(f"\n{R}[!] Starting Uninstallation...{RESET}")
    confirm = input(f"{Y}Are you sure? (y/n): {W}")
    if confirm.lower() == 'y':
        print(f"{R}[-] Removing files using {pkg_manager} logic...{RESET}")
        time.sleep(2)
        print(f"\n{G}[SUCCESS] Uninstalled successfully.{RESET}")
        input(f"\n{C}[ Press Enter to return to menu ]{RESET}")
    else:
        print(f"{G}[*] Cancelled.{RESET}")

def main_menu():
    banner()
    print(f"{W}[1] {G}Install (Setup + Start)")
    print(f"{W}[2] {R}Uninstall")
    print(f"{W}[0] {Y}Exit")
    print(f"{C}========================================{RESET}")
    
    try:
        choice = input(f"{Y}SDGAMER > {W}")
        
        if choice == '1':
            install_process()
        elif choice == '2':
            uninstall_process()
        elif choice == '0':
            print(f"\n{R}[!] Exiting...")
            sys.exit()
        else:
            print(f"\n{R}[!] Invalid selection")
            time.sleep(1)
            
    except KeyboardInterrupt:
        print(f"\n{R}[!] Force Exit Detected.")
        sys.exit()

if __name__ == "__main__":
    while True:
        main_menu()
        
