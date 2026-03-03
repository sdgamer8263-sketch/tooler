import os
import sys
import time
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

def clear_screen():
    os.system('cls' if os.name == 'nt' else 'clear')

def banner():
    clear_screen()
    # SDGAMER Banner
    logo = f"""{G}
      ____  ____  ____    _    __  __ _____ ____  
     / ___||  _ \/ ___|  / \  |  \/  | ____|  _ \ 
     \___ \| | | | |  _  / _ \ | |\/| |  _| | |_) |
      ___) | |_| | |_| |/ ___ \| |  | | |___|  _ < 
     |____/|____/ \____/_/   \_\_|  |_|_____|_| \_\\
    {R}
         [ Created for SDGAMER ]
         [ Version 2.0         ]
    {RESET}"""
    print(logo)
    print(f"{C}========================================{RESET}")

def install_process():
    print(f"\n{G}[+] Starting Setup...{RESET}")
    time.sleep(1)
    # Add your actual install commands here
    # Example: os.system('pkg install git -y')
    print(f"{Y}[*] Installing dependencies...{RESET}")
    time.sleep(2)
    print(f"{Y}[*] Configuring environment...{RESET}")
    time.sleep(2)
    print(f"\n{G}[SUCCESS] Installation Complete!{RESET}")
    print(f"{G}[+] Starting Tool now...{RESET}")
    # Add command to start the tool here

def uninstall_process():
    print(f"\n{R}[!] Starting Uninstallation...{RESET}")
    confirm = input(f"{Y}Are you sure? (y/n): {W}")
    if confirm.lower() == 'y':
        time.sleep(1)
        # Add your actual remove commands here
        # Example: os.system('rm -rf /folder/path')
        print(f"{R}[-] Removing files...{RESET}")
        time.sleep(2)
        print(f"{R}[-] Cleaning cache...{RESET}")
        time.sleep(1)
        print(f"\n{G}[SUCCESS] Uninstalled successfully.{RESET}")
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
            main_menu()
            
    except KeyboardInterrupt:
        print(f"\n{R}[!] Force Exit Detected.")
        sys.exit()

if __name__ == "__main__":
    while True:
        main_menu()
        input(f"\n{C}[Press Enter to return to menu]{RESET}")
        
