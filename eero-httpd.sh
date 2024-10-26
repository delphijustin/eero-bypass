#!/bin/bash
echo 'HTTP/1.0 200 OK'
echo 'Content-type: text/html'
echo 'Cache-Control: no-store, no-cache, must-revalidate, max-age=0'
echo 'Pragma: no-cache'
echo 'Expires: 0'
echo ''
echo '<!DOCTYPE html>'
echo '<html>'
echo '<head>'
echo '<script>'
echo "function refreshPage(){location.pathname='/$RANDOM';}"
echo 'function startTimer(){'
echo 'if("/"==location.pathname)refreshPage();'
echo 'setTimeout(function(){'
echo 'refreshPage();'
echo '},60000);}</script>';
echo '</head>'
echo '<body onload="startTimer()">'
echo "<form method='get' action='/$RANDOM'>"
cat /tmp/eero-status.http
echo ''
echo '<input type="submit" value="Refresh">'
echo '</form><img src="//delphianserver.com/online-icon.php">'
echo '</body>'
echo '</html>'
