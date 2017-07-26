#!/bin/bash

version=$1

# If the version is empty assign the latest version.
#if [ "$version" == "" ];
#then
  version=2.9.2
#fi

# install the requirements

yum install -y java

# set environment 

cat >> /etc/profile <<EOF
export JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk
export JRE_HOME=/usr/lib/jvm/jre
EOF

# reload profile

source /etc/profile

# change the current working directory

cd /opt

# download the kafka tar file

wget http://apache.mivzakim.net/kafka/0.8.2.0/kafka_$version-0.8.2.0.tgz 

# untar the file

tar -zxvf kafka_$version-0.8.2.0.tgz

# change directory to kafka directory

cd /opt/kafka_$version-0.8.2.0/bin

# change the heap size

sed -i 's/"-Xmx512M -Xms512M"/"-Xmx256M -Xms128M"/g' *.sh
sed -i 's/"-Xmx512M"/"-Xms128M"/g' *.sh
sed -i 's/"-Xmx1G -Xms1G"/"-Xmx256M -Xms128M"/g' *.sh

#start zookeeper service

zookeeper-server-start.sh -daemon config/zookeeper.properties

#start kafka server

kafka-server-start.sh config/server.properties
