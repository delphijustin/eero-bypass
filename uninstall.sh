#!/bin/bash
rm eero-bypass.sh
rm /usr/local/bin/eero-bypass.py
if [[ "$1" == "all" ]]
then
rm /etc/eero-bypass.conf
rm ~/wan-timer.txt
rm ~/eero-clicker.log
fi
rm ~/.config/autostart/eero-bypass.desktop
