#!/bin/bash

#creating repo
cat >>/etc/yum.repos.d/wandisco-svn.repo <<EOF
[WandiscoSVN]
name=Wandisco SVN Repo
baseurl=http://opensource.wandisco.com/centos/7/svn-1.9/RPMS/$basearch/
enabled=1
gpgcheck=0
EOF

#remove old version

yum remove subversion*

yum clean all

#install new subversion

yum install -y subversion

#check svn version

svn --version

