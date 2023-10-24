#!/bin/bash

# Set your Telegram bot token and chat ID
TELEGRAM_BOT_TOKEN="TELEGRAM_BOT_TOKEN"
TELEGRAM_CHAT_ID="TELEGRAM_CHAT_I"

# Update package lists
apt update

# Check if there are any upgrades
upgrade_info=$(apt list --upgradable 2>/dev/null)
if [[ -n $upgrade_info ]]; then
    # Perform system upgrade
    apt upgrade -y && apt autoremove -y

    # Send Telegram message about successful upgrade
    message="🚀 System successfully upgraded."
else
    # Send Telegram message about no upgrades available
    message="👍 No upgrades available."
fi

# Send Telegram message
curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
    -d chat_id="${TELEGRAM_CHAT_ID}" \
    -d text="${message}"
