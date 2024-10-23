#!/bin/bash
echo "HTTP/1.0 200 OK"
echo "Content-type: text/html"
echo ""
export DISPLAY=:99
echo '<!doctype html>'
echo '<html>'
echo '<body>Success:<p>'
echo '<pre>'
python3 /usr/local/bin/eero-bypass.py
echo '</pre>'
echo '</body>'
echo '</html>'
