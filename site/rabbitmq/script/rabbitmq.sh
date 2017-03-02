#!/bin/sh

# Attributes.
DIR=/var/lib
version=$1
URL=https://www.rabbitmq.com/releases/rabbitmq-server/v$version/rabbitmq-server-$version-1.noarch.rpm

# Move into local directory.
cd $DIR

# Wget & install RabbitMQ.
if [ "$version" != "" ];
then
  # Wget RabbitMQ package.
  wget $URL

  # Import RabbitMQ key file.
  rpm --import https://www.rabbitmq.com/rabbitmq-signing-key-public.asc

  # Install RabbitMQ.
  yum install -y rabbitmq-server-$version-1.noarch.rpm
else
  wget https://www.rabbitmq.com/releases/rabbitmq-server/v3.6.5/rabbitmq-server-3.6.5-1.noarch.rpm
  rpm --import https://www.rabbitmq.com/rabbitmq-signing-key-public.asc
  yum install -y rabbitmq-server-3.6.5-1.noarch.rpm
fi

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
