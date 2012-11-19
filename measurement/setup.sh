#!/bin/bash
# Set up measurement environment for collecting page speed info.
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
