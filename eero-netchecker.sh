#!/bin/bash
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
    ./eeroportal-onreconnect.sh down
    python3 eeroportal-bypass.py
    ./eeroportal-onreconnect.sh up
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
    printf "${duration} seconds left before reconnection"
    echo ""
    echo $duration seconds left before reconnection > ~/wan-timer.txt
    duration=$(expr $duration - 10)
done
