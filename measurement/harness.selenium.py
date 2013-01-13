"""
Test harness for page speed measurments using selenium.
"""
from selenium import webdriver
import subprocess
import sys
import time

# 0. Get arguments.
url = sys.argv[1]
if not url.startswith("http"):
  url = "http://" + url

# 1. Start up the server.
server = subprocess.Popen(["java", "-jar", "selenium.jar"])

# 2. Potentially configure a Proxy.
profile = webdriver.FirefoxProfile()
profile.set_preference("network.proxy.socks", "localhost")
profile.set_preference("network.proxy.socks_port", 8080)
profile.set_preference("network.proxy.type", 1)

# 3. Control a client.
browser = webdriver.Firefox(profile)
start = time.time()
browser.get(url)
end = time.time()

# 4. Report.
print url, (end - start) * 1000

# 5. Clean up.
browser.close()
server.kill()