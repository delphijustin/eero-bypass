#!/bin/bash
rm /usr/local/bin/eero-bypass.sh
rm /usr/local/bin/eero-bypass.py
rm /usr/share/eero-bypass/eerodefault.wav
rm /usr/share/eero-bypass/eeropopup.sh
rmdir /usr/share/eero-bypass
if [[ "$1" == "all" ]]
then
rm /etc/eero-bypass.conf
rm /tmp/eerostatus.http
fi
