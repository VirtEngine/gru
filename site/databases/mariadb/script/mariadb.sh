#!/bin/bash

# If the version is empty assign the latest version.
if [ "$version" == "" ];
then
  version=10.2.7
fi

# Creating repository

cat > /etc/yum.repos.d/MariaDB.repo <<EOF
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/$version/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
EOF

# install mariadb

yum install -y MariaDB-server install MariaDB-client

# start mariadb

sudo systemctl start mariadb

# start  mysql

sudo /etc/init.d/mysql start
