"""
Test harness for page speed measurments using selenium.
"""
from pyvirtualdisplay import Display
from selenium import webdriver
import subprocess
import sys
import time

# 0. Get arguments.
url = sys.argv[1]
if not url.startswith("http"):
  url = "http://" + url

# 1. Start up the server.
display = Display(visible=0, size=(800, 600))
display.start()
server = subprocess.Popen(["java", "-jar", "selenium.jar"])

# 2. Potentially configure a Proxy.
profile = webdriver.FirefoxProfile()
profile.set_preference("network.proxy.socks", "localhost")
profile.set_preference("network.proxy.socks_port", 9050)
profile.set_preference("network.proxy.type", 1)

# 3. Control a client.
browser = webdriver.Firefox(profile)
start = time.time()
browser.get(url)
end = time.time()

# 4. Report.
request_start = browser.execute_script("return window.performance.timing.requestStart;")
response_start = browser.execute_script("return window.performance.timing.responseStart;")
response_end = browser.execute_script("return window.performance.timing.responseEnd;")

ttfb = response_start - request_start
ttlb = response_end - request_start
tt = (end - start) * 1000

print "%s %s %s %s" % (url, ttfb, ttlb, tt, )

# 5. Clean up.
browser.close()
display.stop()
server.kill()