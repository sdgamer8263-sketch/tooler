#!/bin/bash

# System update করা হচ্ছে
echo "Updating system..."
sudo apt update -y

# Wget ইনস্টল করা হচ্ছে
echo "Installing wget..."
sudo apt install wget -y

# Playit ডাউনলোড করা হচ্ছে
echo "Downloading playit..."
wget https://github.com/playit-cloud/playit-agent/releases/latest/download/playit-linux-amd64

# Execution permission দেওয়া হচ্ছে
echo "Setting permissions..."
chmod +x playit-linux-amd64

# Dropbear ইনস্টল এবং কনফিগার করা হচ্ছে
echo "Installing Dropbear..."
sudo apt install dropbear -y
sudo dropbear -p 22

# পাসওয়ার্ড সেট করার প্রম্পট
echo "Please set your password:"
sudo passwd

# Playit রান করা হচ্ছে
echo "Starting playit..."
./playit-linux-amd64
