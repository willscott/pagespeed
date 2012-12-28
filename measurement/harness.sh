#!/bin/bash

BINARY="./phantomjs"
SCRIPT="gettime.js"
MAC=`uname`
LIMIT=30
XVFB=0

if [ -z "$DISPLAY" ] && [ "$MAC" != "Darwin" ]
then
	XVFB=1
	sudo killall -q -9 Xvfb
	sleep 2
	Xvfb :1 -screen 0 1024x768x8 -fc fixed && env DISPLAY=:1 >/dev/null 2>&1 &
	disown
	sleep 2
	export DISPLAY=:1
fi

if [ -z "$1" ]
then
  PROXY=""
else
  PROXY="--proxy-type=socks5 --proxy=127.0.0.1:27004"
fi

if [ "$MAC" == "Darwin" ]
then
	pkill runner.bash
	pkill $BINARY
	sleep 1
	pkill -9 $BINARY
else
	killall -q runner.bash
	killall -q $BINARY
	sleep 1
	killall -q -9 $BINARY
fi

###Begin###

function run {
  cat > runner.bash <<EOF
#!/bin/bash
out=\`$BINARY $PROXY $SCRIPT $1\`
echo $1 \$out
EOF

  bash runner.bash 2>/dev/null &
  pid=$!
  t=0
  while true
  do
    kill -n 0 $pid >/dev/null 2>&1
    if [ $? -eq 0 ]
    then
      let "t+=1"
      sleep 1
      if [ $t -gt $LIMIT ]
      then
        kill -9 $pid >/dev/null 2>&1
        echo "$1 FAIL Timeout"
        break
      fi
    else
      # process ended.
      break
    fi
  done
}

URLS=$(cat urls.txt)

# warmup
$BINARY $PROXY $SCRIPT http://google.com > /dev/null
$BINARY $PROXY $SCRIPT http://twitter.com > /dev/null
$BINARY $PROXY $SCRIPT http://linkedin.com > /dev/null

# lets do this thing!
for line in $URLS;
do
  run $line
	if [ "$MAC" == "Darwin" ]
	then
		pkill $BINARY
	else
  	killall -q $BINARY
	fi
  sleep 1
done

echo "DONE"
if [ "$XVFB" == "1" ]
then
	killall -q Xvfb
	sleep 1
	killall -q -9 Xvfb
fi
exit 0
