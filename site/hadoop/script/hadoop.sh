#!/bin/bash

# install java

cd /opt/

wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.tar.gz"

tar xzf jdk-8u131-linux-x64.tar.gz

cd /opt/jdk1.8.0_131/

alternatives --set jar /opt/jdk1.8.0_131/bin/jar

alternatives --set javac /opt/jdk1.8.0_131/bin/javac

export JAVA_HOME=/opt/jdk1.8.0_131

export JRE_HOME=/opt/jdk1.8.0_131/jre

# export PATH=$PATH:/opt/jdk1.8.0_131/bin:/opt/jdk1.8.0_131/jre/bin

# create user

adduser hadoop
passwd hadoop

# change user and create passwordless access

su - hadoop
ssh-keygen -t rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 0600 ~/.ssh/authorized_keys

# change to home directory

cd ~

# download hadoop file

wget http://www-eu.apache.org/dist/hadoop/common/hadoop-2.8.0/hadoop-2.8.0.tar.gz 

tar xzf hadoop-2.8.0.tar.gz

# rename the directory

mv hadoop-2.8.0 hadoop

# setup environment

cat >>~/.bashrc <<EOF
export HADOOP_HOME=/home/hadoop/hadoop
export HADOOP_INSTALL=$HADOOP_HOME
export HADOOP_MAPRED_HOME=$HADOOP_HOME
export HADOOP_COMMON_HOME=$HADOOP_HOME
export HADOOP_HDFS_HOME=$HADOOP_HOME
export YARN_HOME=$HADOOP_HOME
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin
EOF

source ~/.bashrc

# setup java environment variables
export JAVA_HOME=/opt/jdk1.8.0_131/

# change directory

cd /root/hadoop/etc/hadoop

# setup core-site configuration

cat >>core-site.xml <<EOF
<configuration>
<property>
  <name>fs.default.name</name>
    <value>hdfs://localhost:9000</value>
</property>
</configuration>
EOF

# setup hdfs-site configuration

cat >>hdfs-site.xml <<EOF
<configuration>
<property>
 <name>dfs.replication</name>
 <value>1</value>
</property>

<property>
  <name>dfs.name.dir</name>
    <value>file:///home/hadoop/hadoopdata/hdfs/namenode</value>
</property>

<property>
  <name>dfs.data.dir</name>
    <value>file:///home/hadoop/hadoopdata/hdfs/datanode</value>
</property>
</configuration>
EOF


# setup marped-site configuration

cat >>mapred-site.xml.template <<EOF
<configuration>
 <property>
  <name>mapreduce.framework.name</name>
   <value>yarn</value>
 </property>
</configuration>
EOF


# yarn-site.xml 

cat >>yarn-site.xml <<EOF
<configuration>
 <property>
  <name>yarn.nodemanager.aux-services</name>
    <value>mapreduce_shuffle</value>
 </property>
</configuration>
EOF
