#!/bin/sh

DIR=/var/lib

# Wget Dependencies URL.
URL1=http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
URL2=http://apache.mirror.digitalpacific.com.au/couchdb/source/$1/apache-couchdb-$1.tar.gz

# Move into local directory.
cd $DIR

# Enable EPEL and REMI repositories for installing couchdb deps.
wget $URL1
rpm -Uvh epel-release-latest-7.noarch.rpm

#Install CouchDB deps.
yum install  -y autoconf autoconf-archive automake libtool perl-Test-Harness erlang libicu-devel js-devel curl-devel gcc-c++

# Wget CouchDB URL & install CouchDB.
wget $URL2
tar -xzf apache-couchdb-$1.tar.gz
cd apache-couchdb-$1
./configure --with-erlang=/usr/lib64/erlang/usr/include
make && make install

#Create CouchDB user.
adduser -r --home /usr/local/var/lib/couchdb -M --shell /bin/bash couchdb

# Change ownership for CouchDB folder.
chown -R couchdb:couchdb /usr/local/etc/couchdb
chown -R couchdb:couchdb /usr/local/var

# Create Symlink.
ln -s /usr/local/etc/rc.d/couchdb /etc/init.d/couchdb

# Default IP changes
sed -ie 's/127.0.0.1/0.0.0.0/g' /usr/local/etc/couchdb/default.ini
