#!/bin/bash
if [[ "$1" == "root" ]]
then
apt install python3-selenium xvfb
cp eero-bypass.py /usr/local/bin/
cp eero-netchecker.sh /usr/local/bin/
cp eero-onreconnect.sh /usr/local/bin/
cat eero-bypass.service.default | sed "s/user_name/$2/g" > /etc/systemd/system/eero-bypass.service
chmod +x /usr/local/bin/eero-netchecker.sh
chmod +x /usr/local/bin/eero-onreconnect.sh
echo "Has not written to this file." > /root/wan-timer.txt
systemctl enable eero-bypass.service
echo ""
echo "To start the service type:"
echo "sudo systemctl start eero-bypass.service"
echo ""
echo "Log file is located in /root/wan-timer.txt"
exit 0
fi
sudo $0 root $USER
