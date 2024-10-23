#!/bin/bash
# Check if script is run as root
if [[ "$EUID" -ne 0 ]]; then
  echo "This script must be run as root. Please run it with sudo."
  exit 1
fi

# Capture the non-root user who invoked sudo
USERNAME=${SUDO_USER:-$USER}

# Install dependencies
apt install -y python3-selenium xvfb

# Copy necessary files to /usr/local/bin
cp eero-bypass.conf /etc/eero-bypass.conf
cp eero-bypass.py /usr/local/bin/
cp eero-bypass.sh /usr/local/bin/

# Replace the username in the service file and place it in systemd
cat eero-bypass.service.default | sed "s/user_name/$USERNAME/g" > /etc/systemd/system/eero-bypass.service

# Make scripts executable
chmod +x /usr/local/bin/eero-bypass.sh

# Create a log file and set appropriate permissions
echo "Has not written to this file." > ~/wan-timer.txt
chmod 666 ~/wan-timer.txt
touch ~/eero-clicker.log
chmod 666 ~/eero-clicker.log

# Final messages
echo ""
echo "Before starting the app you may want to edit /etc/eero-bypass.conf"
echo "To start it type in eero-bypass.sh"
