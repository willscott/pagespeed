#!/bin/bash

BINARY="./phantomjs"
SCRIPT="gettime.js"
LIMIT=30

sudo killall -9 Xvfb
sleep 2
Xvfb :1 -screen 0 1024x768x8 -fc fixed && env DISPLAY=:1 2>&1 >/dev/null &
disown
sleep 2
export DISPLAY=:1

if [ -z "$1" ]
then
  PROXY=""
else
  PROXY="--proxy-type=socks5 --proxy=127.0.0.1:27004"
fi

killall runner.bash 2>&1 >/dev/null
killall $BINARY 2>&1 >/dev/null
sleep 1
killall -9 $BINARY 2>&1 >/dev/null

###Begin###

function run {
  cat > runner.bash <<EOF
#!/bin/bash
out=\`$BINARY $PROXY $SCRIPT http://$1\`
echo $1 \$out
EOF

  bash runner.bash 2>/dev/null &
  pid=$!
  t=0
  while true
  do
    kill -n 0 $pid 2>&1 >/dev/null
    if [ $? -eq 0 ]
    then
      let "t+=1"
      sleep 1
      if [ $t -gt $LIMIT ]
      then
        kill -9 $pid 2>&1 >/dev/null
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
  killall $BINARY 2>&1 >/dev/null
  sleep 1
done

echo "DONE"
killall Xvfb
killall tor
sleep 1
killall -9 Xvfb
killall -9 tor
exit 0
