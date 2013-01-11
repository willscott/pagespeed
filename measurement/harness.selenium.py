"""
Test harness for page speed measurments using selenium.
"""
import subprocess
from selenium import webdriver

# 1. Start up the server.
server = subprocess.Popen(["java", "-jar", "selenium.jar"])

# 2. Potentially configure a Proxy.
profile = webdriver.FirefoxProfile()
profile.set_preference("network.proxy.socks", "localhost")
profile.set_preference("network.proxy.socks_port", 8080)
profile.set_preference("network.proxy.type", 1)

# 3. Control a client.
browser = webdriver.Firefox(profile)
browser.get("http://www.google.com")

# 4. Clean up.
browser.close()
server.kill()