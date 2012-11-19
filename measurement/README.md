## Measurement

These scripts form a test harness around phantomjs to report web page render
time with and without a proxy.

#### Usage

1. Setup

   > ./setup.sh

   Will download the current version of phantomjs, and a list of top websites from alexa for tests.

2. Run

   > ./harness.sh

   Will have phantomjs sequentially attempt to run each of the websites listed in urls.txt.

   > ./harness.sh proxy

   Will cause a proxy to be used for all requests.  The proxy is currently hardcoded in the harness script.

3. Data Cleanup

   > for [file in *]
   > do
   >   cat $file | awk '/^[a-z./\:]+[:space:][:digit:]+[:space:]/ { print $1 " " $2 }' > $file.clean
   > done
