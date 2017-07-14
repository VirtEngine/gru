#!/bin/bash

version=$1

# If the version is empty assign the latest version.
if [ "$version" == "" ];
then
  version=3.9
fi

#creating repo

cat >/etc/yum.repos.d/datastax.repo <<EOF
[datastax-ddc] 
name = DataStax Repo for Apache Cassandra
baseurl = http://rpm.datastax.com/datastax-ddc/$version
enabled = 1
gpgcheck = 0
EOF


# install cassandra

yum -y install datastax-ddc

# start cassandra service

service cassandra start

# init cassandra

/etc/init.d/cassandra start


