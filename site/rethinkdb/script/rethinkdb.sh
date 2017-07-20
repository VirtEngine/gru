#!/bin/bash

version=$1

# If the version is empty assign the latest version.
if [ "$version" == "" ];
then
  version=2.3.5
fi

# change working directory
cd rethinkdb-$version

# build rethinkdb 
./configure --allow-fetch --dynamic jemalloc
make
make install

