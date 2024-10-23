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
cp eero-netchecker.sh /usr/local/bin/
cp eero-onreconnect.sh /usr/local/bin/
cp eero-webreset.sh /usr/local/bin/

# Replace the username in the service file and place it in systemd
cat eero-bypass.service.default | sed "s/user_name/$USERNAME/g" > /etc/systemd/system/eero-bypass.service

# Make scripts executable
chmod +x /usr/local/bin/eero-netchecker.sh
chmod +x /usr/local/bin/eero-onreconnect.sh
chmod +x /usr/local/bin/eero-webreset.sh

# Create a log file and set appropriate permissions
echo "Has not written to this file." > ~/wan-timer.txt
chmod 666 ~/wan-timer.txt
touch ~/eero-clicker.log
chmod 666 ~/eero-clicker.log

# Path to the journald configuration file
JOURNALD_CONF="/etc/systemd/journald.conf"

# Ensure SystemMaxUse is set
sed -i 's/^#SystemMaxUse=.*$/SystemMaxUse=256K/' $JOURNALD_CONF

# If SystemMaxUse line doesn't exist, add it at the end
grep -q "^SystemMaxUse=" $JOURNALD_CONF || echo "SystemMaxUse=256K" | tee -a $JOURNALD_CONF

# Restart the journald service to apply changes
 systemctl restart systemd-journald
 
# Enable the service to start at boot
#systemctl enable eero-bypass.service
#Disabled as it may not do well as a service

# Final messages
echo ""
echo "To install as a service(not recommended) type the following commands:"
echo "sudo systemctl enable eero-bypass.service"
echo "sudo systemctl start eero-bypass.service"
echo ""
echo "Log file is located in ~/wan-timer.txt"
echo "Before starting the service you may want to edit /etc/eero-bypass.conf"
