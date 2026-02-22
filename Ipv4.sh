
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
