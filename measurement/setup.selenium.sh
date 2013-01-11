#!/bin/bash
# Set up measurement environment for collecting page speed info.

# Fetch the latest version of selenium if not present
if [ ! -e "selenium.jar" ]
then
  DOWNLOAD_PAGE=`curl -s https://code.google.com/p/selenium/downloads/list`
	# Grab the standalone server
	URL=`echo "$DOWNLOAD_PAGE" | sed -n '/selenium\.googlecode[^ ]*selenium-server-standalone-[\.0-9]*\.jar/ s/.*\(selenium\.[^ ]*jar\).*/\1/ p'`
	curl -s -O "$URL"
	mv selenium*.jar selenium.jar
	# Grab the python bindings
	URL=`echo "$DOWNLOAD_PAGE" | sed -n '/selenium\.googlecode[^ ]*selenium-[\.0-9]*\.tar\.gz/ s/.*\(selenium\.[^ ]*tar\.gz\).*/\1/ p'`
	curl -s -O "$URL"
	tar xvzf selenium*.tar.gz
	rm selenium*.tar.gz
	mv selenium-*/py/selenium ./
	rm -r selenium-*
fi