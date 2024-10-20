#!/bin/bash
if [[ "$1" == "help" ]]
then
echo "Usage: $0 [options]"
echo "Options:"
echo "bg        Run in the background"
echo "nowrite   Do not keep outputing time left in the console"
exit 0
fi
if [[ "$1" == "bg" ]]
then
echo "Starting EEROPortal bypass in the background"
nohup $0 nowrite &
exit 0
fi
export duration=3600
# Function to check for internet connection
check_internet() {
    # Ping DNS server (9.9.9.9) 1 time with a timeout of 3 seconds
    if ping -q -c 1 -W 3 9.9.9.9 >/dev/null; then
        return 0  # Internet is up
    else
        return 1  # No internet
    fi
}

# Function to relaunch the script
relaunch_script() {
    echo "No internet detected. Restarting the script..."
    echo "Reconnection in progress" > ~/wan-timer.txt
    /usr/local/bin/eero-onreconnect.sh down
    export DISPLAY=:99
    xvfb-run python3 /usr/local/bin/eero-bypass.py
    /usr/local/bin/eero-onreconnect.sh up
    export duration=3600
}

# Main loop to monitor the internet connection
while true; do
    if ! check_internet; then
        # If no internet, relaunch the script
        relaunch_script
    fi

    # Sleep for 10 seconds before checking again
    sleep 10
    if [[ "$1" != "nowrite" ]]
    then
    printf "${duration} seconds left before reconnection"
    echo ""
    fi
    echo $duration seconds left before reconnection > ~/wan-timer.txt
    duration=$(expr $duration - 10)
done
