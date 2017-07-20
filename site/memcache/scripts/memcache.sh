#!/bin/bash

version="1.4.39"

#install pre-requestes

yum -y install gcc
yum -y install make

#change directory

cd memcached-$version

#run configure 

./configure
./configure --enable-threads 
./configure --enable-64bit
make && make install

