#!/bin/bash
systemctl stop eero-bypass.service
systemctl disable eero-bypass.service
rm /usr/local/bin/eero-bypass.py
rm /usr/local/bin/eero-netchecker.sh
if [[ "$1" == "all" ]]
then
rm /usr/local/bin/eero-onreconnect.sh
fi
