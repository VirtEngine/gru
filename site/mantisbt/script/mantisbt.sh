#!/bin/bash

#update repository
sudo yum install epel-release -y
sudo yum update -y

#install apacheserver

sudo yum install httpd -y

#start apache server

sudo systemctl start httpd
sudo systemctl enable httpd

#install mariadb

sudo yum install mariadb mariadb-server -y

#start mariadb

sudo systemctl start mariadb
sudo systemctl enable mariadb

#installing php

sudo rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

sudo yum install php71w php71w-cli php71w-mysqli -y

#create database in mariadb

mysql -u root <<EOFMYSQL

CREATE DATABASE mantisdb;

GRANT ALL PRIVILEGES ON mantisdb.* TO 'mantis'@'localhost' IDENTIFIED BY 'mantispassword';

FLUSH PRIVILEGES;

EOFMYSQL

#install mantisbt

wget https://sourceforge.net/projects/mantisbt/files/mantis-stable/2.5.1/mantisbt-2.5.1.tar.gz

tar -xpf mantisbt-2.5.1.tar.gz

mv mantisbt-2.5.1 /var/www/html/mantis

chown -R apache:apache /var/www/html/mantis/

#create virtualhost file for mantis

cat >>/etc/httpd/conf.d/mantis.conf <<EOF
<VirtualHost *:80>
        ServerAdmin admin@example.com
        DocumentRoot "/var/www/html/mantis"
        ServerName example.com
        <Directory "/var/www/html/mantis/">
                Options FollowSymLinks
                AllowOverride All
                Options MultiViews FollowSymlinks
                AllowOverride All
                Order allow,deny
                Allow from all
        </Directory>
        TransferLog /var/log/httpd/mantis_access.log
        ErrorLog /var/log/httpd/mantis_error.log
</VirtualHost>
EOF

#restart apache

systemctl restart httpd


#enabling http port

sudo firewall-cmd --zone=public --permanent --add-service=http
sudo firewall-cmd --reload
