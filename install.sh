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
cp eero-bypass.py /usr/local/bin/
cp eero-netchecker.sh /usr/local/bin/
cp eero-onreconnect.sh /usr/local/bin/

# Replace the username in the service file and place it in systemd
cat eero-bypass.service.default | sed "s/user_name/$USERNAME/g" > /etc/systemd/system/eero-bypass.service

# Make scripts executable
chmod +x /usr/local/bin/eero-netchecker.sh
chmod +x /usr/local/bin/eero-onreconnect.sh

# Create a log file and set appropriate permissions
echo "Has not written to this file." > ~/wan-timer.txt
chmod 333 ~/wan-timer.txt

# Enable the service to start at boot
systemctl enable eero-bypass.service

# Final messages
echo ""
echo "To start the service type:"
echo "sudo systemctl start eero-bypass.service"
echo ""
echo "Log file is located in ~/wan-timer.txt"
