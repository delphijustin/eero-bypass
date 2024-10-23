from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
import time
import os
eeroexcept=0
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
try:
	driver.get('http://'+os.getenv('dns_ip'))
# Find the button by its HTML attributes (e.g., ID, class, or name)
	button = driver.find_element(By.CLASS_NAME, 'btn')

# Simulate button click
	button.click()

# Optional: wait for page load, interaction
	time.sleep(5)  # Wait 15 seconds for demo purposes
	button1 = driver.find_element(By.CLASS_NAME, 'btn')
	button1.click()

	time.sleep(7)
except:
	eeroexcept=1
# Close browser
driver.quit()
justin@eero-bypass:~$ 
