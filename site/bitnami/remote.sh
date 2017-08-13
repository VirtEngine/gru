#!/usr/bin/env bash

bitnami_dir=/var/lib/megam/bitnami
if [ -d $bitnami_dir ]; then
    rm -rf  $bitnami_dir
fi

mkdir -p $bitnami_dir

cd $bitnami_dir

wget  -O  $bitnami_dir/bitnami-run $1
yum install glib* -Y
chmod 755 bitnami-run
