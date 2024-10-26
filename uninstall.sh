#!/bin/bash
rm eero-bypass.sh
rm /usr/local/bin/eero-bypass.py
rm /usr/local/bin/eero-httpd.sh
if [[ "$1" == "all" ]]
then
rm /etc/eero-bypass.conf
rm /tmp/eero-status.http
fi
rm ~/.config/autostart/eero-bypass.desktop
