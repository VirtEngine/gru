#!/bin/bash

# If the version is empty assign the latest version.
if [ "$version" == "" ];
then
  version=2.0
fi

# install prerequetis

yum install -y epel-release wget

#download scylla repo

wget -O /etc/yum.repos.d/scylla.repo http://downloads.scylladb.com/rpm/centos/scylla-$version.repo

