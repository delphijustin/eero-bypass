#!/bin/bash
# This shell script is executed when the linux udp client gets a command
case "$1" in
EERO_RECONNECT)
# reconnect commands here
;;
EERO_DISCONNECT)
# disconnect commands here
;;
EERO_HELLO)
# Server join commands here
;;
EERO_TIMER*)
# time left warning commands here
;;
*)exit 1 ;;
esac
exit 0
