#!/bin/bash
rm /usr/local/bin/eero-bypass.sh
rm /usr/local/bin/eero-bypass.py
rm /usr/local/bin/eero-httpd.sh
rm /usr/share/eero-bypass/eerodefault.wav
rmdir /usr/share/eero-bypass
if [[ "$1" == "all" ]]
then
rm /etc/eero-bypass.conf
rm /tmp/eerostatus.http
fi
