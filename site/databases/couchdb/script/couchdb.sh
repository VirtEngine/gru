#!/bin/sh

# Attributes.
DIR=/var/lib
URL1=http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
version=$1

# If the version is empty assign the latest version.
if [ "$version" == "" ];
then
  version=1.6.1
fi

URL2=http://apache.mirror.digitalpacific.com.au/couchdb/source/$version/apache-couchdb-$version.tar.gz

# Move into local directory.
cd $DIR

# Enable EPEL and REMI repositories for installing couchdb deps.
wget $URL1
rpm -Uvh epel-release-latest-7.noarch.rpm

#Install CouchDB deps.
yum install  -y autoconf autoconf-archive automake libtool perl-Test-Harness erlang libicu-devel js-devel curl-devel gcc-c++

# Wget CouchDB URL & install CouchDB.
wget $URL2
tar -xzf apache-couchdb-$version.tar.gz
cd apache-couchdb-$version
./configure --with-erlang=/usr/lib64/erlang/usr/include
make && make install

#Create CouchDB user.
adduser -r --home /usr/local/var/lib/couchdb -M --shell /bin/bash couchdb

# Change ownership for CouchDB folder.
chown -R couchdb:couchdb /usr/local/etc/couchdb
chown -R couchdb:couchdb /usr/local/var

# Create Symlink.
ln -s /usr/local/etc/rc.d/couchdb /etc/init.d/couchdb

# Default IP changes.
sed -ie 's/127.0.0.1/0.0.0.0/g' /usr/local/etc/couchdb/default.ini

# Start CouchDB services.
/usr/local/etc/rc.d/couchdb start

# Enable Firewall port in centos to see web interface.
firewall-cmd --permanent --add-port=5984/tcp
firewall-cmd --reload
