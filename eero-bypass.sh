#!/bin/bash
echo "PLEASE IGNORE ANY BLOCKED MESSAGES EERO"
echo "MAY TELL YOU. IT USUALLY MEANS YOU ARE "
echo "ALREADY CONNECTED"
echo ""
echo "Also keep the chrome browser opened as"
echo "it needs it to stay connected"
source /etc/eero-bypass.conf
nohup python3 /usr/local/bin/eero-bypass.py $dns_eero &
