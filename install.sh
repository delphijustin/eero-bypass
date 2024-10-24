#!/bin/bash
function createDesktopFile(){
autostart_dir="/home/$USERNAME/.config/autostart"
desktop_file="$autostart_dir/eero-bypass.desktop"
read -p "Create X11 autostart file? type yes or no: " choice
if [[ "$choice" == "yes" ]]
then
if [ ! -d "$autostart_dir" ]; then
  mkdir -p "$autostart_dir"
  echo "Created autostart directory: $autostart_dir"
fi
# Define the path of the .desktop file
desktop_entry="[Desktop Entry]
Type=Application
Name=EERO-Bypass
Exec=/usr/local/bin/eero-bypass.sh
Comment=EERO Captive portal autologin
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
X-KDE-autostart-after=panel
X-LXQt-autostart=true"
# Write the .desktop file
echo "$desktop_entry" > "$desktop_file"

# Make the .desktop file executable (optional)
chmod +x "$desktop_file"
else
if [[ "$choice" != "no" ]]
echo "Please type yes or no in lowercase letters."
createDesktopFile
fi
fi
}
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

cat eero-bypass.service.default | sed "s/user_name/$USERNAME/g" > /etc/systemd/system/eero-bypass.service
createDesktopFile
# Make scripts executable
chmod +x /usr/local/bin/eero-bypass.sh

# Create a log file and set appropriate permissions
echo "Has not written to this file." > ~/wan-timer.txt
chmod 666 ~/wan-timer.txt
touch ~/eero-clicker.log
chmod 666 ~/eero-clicker.log

createDesktopFile()
# Final messages
echo ""
echo "Before starting the app you may want to edit /etc/eero-bypass.conf"
echo "To start it type in eero-bypass.sh"
