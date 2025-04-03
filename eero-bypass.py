from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from datetime import datetime
from datetime import timedelta
import time
import sys
import random
import os
import socket
import re
lastOp = -1
timeAlert = int(sys.argv[8])
BROADCAST_IP = sys.argv[4]  # Broadcast address
UDPPORT = int(sys.argv[5])  # Port to send to
start_time = datetime.now()
seconds_elapsed=0
newError=-2
oldError=-1
processIds = sys.argv[2]+"p"+str(os.getpid())+"p"+sys.argv[3]+"p"+sys.argv[6]
eeroTime=int(sys.argv[1])
# Set up Chrome options to run in headless mode
chrome_options = Options()
chrome_options.add_argument("--headless")  # Enable headless mode
chrome_options.add_argument("--no-sandbox")  # Required in some environments
chrome_options.add_argument("--disable-dev-shm-usage")
chrome_options.add_argument("--disable-gpu")  # Disable GPU hardware acceleration

# Define the path to your ChromeDriver
chrome_driver_path = "/usr/bin/chromedriver"

# Set up the Service object
service = Service(chrome_driver_path)

# Initialize the WebDriver
driver = webdriver.Chrome(service=service)

def udpSend(op):
	global lastOp
	if UDPPORT == 0:
		return
	sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)  # Create UDP socket
	sock.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)  # Enable broadcasting
	if(op==0)and(op!=lastOp):
		sock.sendto(b"EERO_HELLO\n", (BROADCAST_IP, UDPPORT))
	if(op==1)and(op!=lastOp):
		sock.sendto(b"EERO_DISCONNECT\n", (BROADCAST_IP, UDPPORT))
	if(op==2)and(op!=lastOp):
		sock.sendto(b"EERO_RECONNECT\n", (BROADCAST_IP, UDPPORT))
	if(op==3)and(op!=lastOp):
		eero_timercmd=f"EERO_TIMER{timeAlert}\n"
		eero_timerbytes=eero_timercmd.encode("ascii")
		sock.sendto(eero_timerbytes, (BROADCAST_IP, UDPPORT))
	if op==4:
		eero_seccmd=f"EERO_SEC{seconds_elapsed}\n"
		eero_secbytes=eero_seccmd.encode("ascii")
		sock.sendto(eero_secbytes, (BROADCAST_IP, UDPPORT))
	time.sleep(5)
	if op!=4:
		lastOp=op
	sock.close()
def resetConnection():
	try:
		htmlfailed = False
		html = driver.page_source
		if driver.title != "eero Timer":
			html = '<html><head><title>eeroBypass - Reconnecting...</title><script>function redirectTimer(){setTimeout(function(){location.search="?lastUpdated="+new Date().toLocaleString().replaceAll(" ","");},10240);}</script></head><body onload="redirectTimer()">Reconnecting... Please wait</body></html>'
		html_size = len(html)
		with open("/tmp/eerostatus.http", "w") as file:
			file.write(f"HTTP/1.0 200 OK\nServer: delphijustin eero-bypass\nContent-type: text/html\nContent-Length: {html_size}\nCache-Control: no-store, no-cache, must-revalidate, max-age=0\nPragma: no-cache\nExpires: 0\nX-Robots-Tag: noindex, nofollow\n\n{html}")
	except:
		htmlfailed=True
	eeroTime=int(sys.argv[1])
	try:
# Find the button by its HTML attributes (e.g., ID, class, or name)
		button = driver.find_element(By.CLASS_NAME, 'btn')
# Simulate button click
		button.click()

# Optional: wait for page load, interaction
		time.sleep(5)  # Wait 5 seconds
		button1 = driver.find_element(By.CLASS_NAME, 'btn')
		button1.click()
		udpSend(1)
		time.sleep(7)
		return 0
	except:
		udpSend(2)
	return 1
udpSend(0)
while True:
	newError=resetConnection()
	now = datetime.now()
	if newError != oldError:
		if newError == 0:
			print(now.strftime("%H:%M:%S")+" Just got back online")
			start_time = datetime.now()
		elif newError == 1:
			print(now.strftime("%H:%M:%S")+" You could be online or there was an error")
	end_time = datetime.now()
	olderror = newError
	updatedAt = end_time.strftime("%m/%d/%Y,%I:%M:%S%p")
	seconds_elapsed=int((end_time - start_time).total_seconds())
	udpSend(4)
	eeroTime=int(sys.argv[1])
	driver.execute_script(f"location.href='http://delphianserver.com/eerotest/?updatedAt={updatedAt}&time={seconds_elapsed}&limit={eeroTime}&pids={processIds}';")  # JavaScript to retry
	time.sleep(int(sys.argv[7]))
	try:
		if driver.execute_script("return timeleft;")<timeAlert*60:
			print(now.strftime("%H:%M:%S")+f" - WARNING INTERNET WILL RESET IN {timeAlert} minute(s)")
			udpSend(3)
	except:
		pass
