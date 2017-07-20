#!/bin/bash

# install Prerequisites(java)

yum install -y java

export JAVA_HOME=/opt/jdk1.8.0_25

export JRE_HOME=/opt/jdk1.8.0_25/jre

export PATH=$PATH:/opt/jdk1.8.0_25/bin:/opt/jdk1.8.0_25/jre/bin


# install openssh

yum -y install openssh-server openssh-client

chkconfig sshd on
service sshd start

#geneate keypairs

ssh-keygen -t rsa -P ""

# configure ssh

cat /.ssh/id_rsa.pub >>/.ssh/authorized_keys

# install flink

wget http://www-eu.apache.org/dist/flink/flink-1.3.1/flink-1.3.1-bin-hadoop27-scala_2.11.tgz

tar xzf flink-1.3.1-bin-hadoop27-scala_2.11.tgz

# setup configuration

cat >>~/.bashrc <<EOF
export FLINK_HOME=/home/flink-1.3.1/
export PATH=$PATH:$FLINK_HOME/bin
EOF




