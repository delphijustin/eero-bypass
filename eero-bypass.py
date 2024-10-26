from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from datetime import datetime
import threading
import time
import sys
import os
import re
oldError=-1
dnsip=sys.argv[1:][0]
eeroTime=int(sys.argv[1:][1])
timerActive=False
expires=-eeroTime
resetAt=datetime.now()
resetAtStr=resetAt.strftime("%H:%M:%S %m/%d/%Y");
def eeroTimer():
	timerActive = True
	while timerActive:
		expires = eeroTime
		resetAt = datetime.now()
		resetAtStr=resetAt.strftime("%H:%M:%S %m/%d/%Y");
		for t in range(eeroTime):
			expires=eeroTime-t
			with open("/tmp/eero-status.http","w") as file:
				file.write("<p>\nReset happend at "+resetAtStr+"<br>\n")
				file.write(f"Timeleft: {expires} minute(s), currently on minute#{t}<br>\n")
				file.write(f"Time limit configured: {eeroTime} minutes<br></p>\n")
			time.sleep(60)

if os.path.getsize("/tmp/eero-status.http")<1:
	with open("/tmp/eero-status.http","w") as file:
		file.write("No disconnects yet!")
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
# Open the captive portal page
def resetConnection():
	try:
		driver.get("http://"+dnsip)
# Find the button by its HTML attributes (e.g., ID, class, or name)
		button = driver.find_element(By.CLASS_NAME, 'btn')
# Simulate button click
		button.click()

# Optional: wait for page load, interaction
		time.sleep(5)  # Wait 5 seconds
		button1 = driver.find_element(By.CLASS_NAME, 'btn')
		button1.click()
		time.sleep(7)
		if not timerActive:
			timerThr = threading.Thread(target=eeroTimer)
			timerThr.start()
			timerActive = True
		return 0
	except:
		return 1
while True:
	newError=resetConnection()
	now = datetime.now()
	if newError != oldError:
		if newError == 0:
			print(now.strftime("%H:%M:%S")+" Just got back online")
		if newError == 1:
			print(now.strftime("%H:%M:%S")+" You could be online or there was an error")
	oldError=newError
	driver.execute_script(f"document.body.innerHTML='Please keep this browser window running.<br>Last action was at {resetAtStr}<br>Last Error: {newError}<br><img src=\"//delphianserver.com/online-icon.php\"></p>';")
	time.sleep(15)
	driver.execute_script("location.href='http://"+dnsip+"';")  # JavaScript to retry
