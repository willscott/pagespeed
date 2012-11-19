#!/bin/bash
# Set up measurement environment for collecting page speed info.

# Fetch the latest version of phantomjs if not present
if [ ! -e "phantomjs" ]
then
	ARCH=`uname -m`
	DOWNLOAD_PAGE=`curl -s https://code.google.com/p/phantomjs/downloads/list`
	if [ "$ARCH" == "x86_64" ]
	then
		URL=`echo "$DOWNLOAD_PAGE" | sed -n '/phantomjs\.googlecode[^ ]*linux-x86_64.tar.bz2/ s/.*\(phantomjs\.[^ ]*bz2\).*/\1/ p'`
	else
		URL=`echo "$DOWNLOAD_PAGE" | sed -n '/phantomjs\.googlecode[^ ]*linux-i686.tar.bz2/ s/.*\(phantomjs\.[^ ]*bz2\).*/\1/ p'`	
	fi
	curl -s -O "$URL"
	tar xjf phantomjs*.bz2
	rm phantomjs*.bz2
	mv phantomjs*/bin/phantomjs ./
	rm -r phantomjs-*
fi

# Fetch a default workload of default pages for top 100 alexa domains.
if [ ! -e "urls.txt" ]
then
	curl -s -O http://s3.amazonaws.com/alexa-static/top-1m.csv.zip
	unzip top-1m.csv.zip && rm top-1m.csv.zip
	cat top-1m.csv | head -100 | awk -F',' '{print "http://"$2}' > urls.txt
	rm top-1m.csv
fi
