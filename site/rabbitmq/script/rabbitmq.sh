#!/bin/sh

# Attributes.
DIR=/var/lib
version=$1

# If the version is empty assign the latest version.
if [ "$version" == "" ];
then
  version=3.6.5
fi

# Wget URL for RabbitMQ.
URL=https://www.rabbitmq.com/releases/rabbitmq-server/v$version/rabbitmq-server-$version-1.noarch.rpm

# Move into local directory.
cd $DIR

# Wget RabbitMQ package.
wget $URL

# Import RabbitMQ key file.
rpm --import https://www.rabbitmq.com/rabbitmq-signing-key-public.asc

# Install RabbitMQ.
yum install -y rabbitmq-server-$version-1.noarch.rpm

# Enable Firewall port in centos to see web interface.
firewall-cmd --permanent --add-port=15672/tcp
firewall-cmd --reload

# Start RabbitMQ services.
systemctl start rabbitmq-server

# Access RabbitMQ management console
rabbitmq-plugins enable rabbitmq_management

# Changing ownership & Creating User to access RabbitMQ
chown -R rabbitmq:rabbitmq /var/lib/rabbitmq
rabbitmqctl add_user VirtEngine VirtEngine
rabbitmqctl set_user_tags VirtEngine administrator
