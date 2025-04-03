#!/bin/bash
source /etc/eero-bypass.conf
if [ "$1" == "udp" ]
then
now=$(date +%T%p)
read -t 5 eeroOp
case "$eeroOp" in
EERO_HELLO) notify-send "eeroBypass" "$now - eeroBypass service has started" ;;
EERO_DISCONNECT) notify-send "eeroBypass" "$now - eero Router has disconnected" ;;
EERO_RECONNECT) notify-send "eeroBypass" "$now - eero Router has been reconnected" ;;
EERO_TIMER*)
 timerwarning=$(echo "$eeroOp" | grep -o '[0-9]\+')
 notify-send "eeroBypass" "$now - Internet will be lost in $timerwarning minutes"
exit 0
 ;;
*)exit 1 ;;
esac
$soundPlayer /usr/share/eero-bypass/eerodefault.wav
exit 0
fi
udppid=none
function startNotify(){
echo "Starting eero-bypass notify client..."
nohup ncat --udp -k -l $UDPPort --sh-exec "eero-bypass.sh udp" &
udppid=$!
}
case "$NotifyMode" in
    1) startNotify ;;
    2)  startNotify
exit 0;;
    *) false ;;
esac
ncatpid=none
if [ "$httpport" != "" ]
then
echo "Starting web server..."
touch /tmp/eerostatus.http
nohup ncat -k -l $httpport --sh-exec "cat /tmp/eerostatus.http" &
ncatpid=$!
fi
echo "Starting up eeroBypass Service..."
while true; do
python3 /usr/local/bin/eero-bypass.py $timelimit $$ $ncatpid $broadcastIP $UDPPort $udppid $delay $timeAlert
echo "Restarting in 15 seconds..."
sleep 15s
echo "Now restarting..."
done
