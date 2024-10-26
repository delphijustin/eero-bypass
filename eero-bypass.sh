#!/bin/bash
source /etc/eero-bypass.conf
if [[ "$1" == "stop" ]]
then
if [[ "$2" != "auto" ]]
then
echo "THIS WILL KILL ALL PYTHON,NCAT AND CHROME PROCESSES"
echo "Continue?"
read -p "Type 1 for yes, 0 for no: " choice
else
choice=1
fi
if [[ "$choice" == "0" ]]
then
exit 0
fi
if [[ "$choice" == "1" ]]
then
killall python3 chrome ncat
fi
exit 0
fi
touch /tmp/eero-status.http
if [[ "$eero_status_port" != "0" ]]
then
nohup ncat -k -l $eero_status_port --sh-exec "/usr/local/bin/eero-httpd.sh" > eero-httpd.log 2>&1 &
fi
nohup python3 /usr/local/bin/eero-bypass.py $dns_eero $timelimit > eero-bypass.log 2>&1 &
