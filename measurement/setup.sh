#!/bin/bash
# Set up measurement environment for collecting page speed info.

# Fetch the latest version of phantomjs if not present
if [ ! -e "phantomjs" ]
then
	MAC=`uname`
	ARCH=`uname -m`
	DOWNLOAD_PAGE=`curl -s https://code.google.com/p/phantomjs/downloads/list`
	if [ "$MAC" == "Darwin" ]
	then
		URL=`echo "$DOWNLOAD_PAGE" | sed -n '/phantomjs\.googlecode[^ ]*macosx.zip/ s/.*\(phantomjs\.[^ ]*zip\).*/\1/ p'`
	else
		if [ "$ARCH" == "x86_64" ]
		then
			URL=`echo "$DOWNLOAD_PAGE" | sed -n '/phantomjs\.googlecode[^ ]*linux-x86_64.tar.bz2/ s/.*\(phantomjs\.[^ ]*bz2\).*/\1/ p'`
		else
			echo "There isn't a premade i386 build of phantomjs, you will need to compile it from source."
			exit 0
		fi
	fi
	curl -s -O "$URL"
	if [ "$MAC" == "Darwin" ]
	then
		unzip phantomjs*.zip
		rm phantomjs*.zip
	else
		tar xjf phantomjs*.bz2
		rm phantomjs*.bz2
	fi
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
