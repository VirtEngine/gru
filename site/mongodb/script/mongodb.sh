#!/bin/bash

# Attributes.
DIR=/var/lib
version=$1

# If the version is empty assign the latest version.
if [ "$version" == "" ];
then
  version=3.4
fi

# Adding the MongoDB Repository
 
cat >/etc/yum.repos.d/mongodb-org.repo <<EOF
[mongodb-org-$version]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/7/mongodb-org/$version/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-$version.asc
EOF


