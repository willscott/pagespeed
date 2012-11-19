# Install LibEvent, a dependency for tor that plab nodes don't have.
if [ ! -e "libevent-1.4.13-1.i386.rpm" ]
then
  curl -O http://mirror.centos.org/centos/5/os/i386/CentOS/libevent-1.4.13-1.i386.rpm
fi
sudo rpm --quiet -i libevent-1.4.13-1.i386.rpm

# Add the tor repo.
cat > torproject.repo << EOF
[torproject]
name=Tor and Vidalia
enabled=1
autorefresh=0
baseurl=http://deb.torproject.org/torproject.org/rpm/centos5/
type=rpm-md
gpgcheck=1
gpgkey=http://deb.torproject.org/torproject.org/rpm/RPM-GPG-KEY-torproject.org
EOF
sudo mv torproject.repo /etc/yum.repos.d

# Intall tor.
sudo yum install -qy --nogpgcheck tor

# Get to good state.
sudo killall tor
sleep 10

sudo killall -9 tor
sleep 10

version=`tor --version | grep version | awk '{print $3}'`
echo "Testing using Tor version $version"
#if [ ! "$version" == "0.2.2.35" ]
#then
#  echo "Tor not properly installed! should be 2.2.35, was '$version'"
#  exit 1
#fi

# Start tor
echo > tor.out
tor --SocksPort 27004 > tor.out &
disown

until [ `cat tor.out | grep 'Bootstrapped 100%' | wc -l` -eq "1"  ]; do
  sleep 1
done
