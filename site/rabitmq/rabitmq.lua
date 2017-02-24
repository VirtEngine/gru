--
-- Gru module for installing and configuring mysql
--

-- Wget rabbitmq package
arc = resource.shell.new("wget")
arc.command = "wget -O /var/lib/rabbitmq-server-3.6.6-1.el6.noarch.rpm https://www.rabbitmq.com/releases/rabbitmq-server/v3.6.6/rabbitmq-server-3.6.6-1.el6.noarch.rpm"

-- Upload access-keys
key = resource.shell.new("add-key")
key.command = "rpm --import https://www.rabbitmq.com/rabbitmq-signing-key-public.asc"

-- Install rabbit-mq
des = resource.shell.new("install")
des.command = "yum install -y /var/lib/rabbitmq-server-3.6.6-1.el6.noarch.rpm"

-- Enable Firewall port for access web interface
port = resource.shell.new("firewall")
port.command = "firewall-cmd --permanent --add-port=15672/tcp"

-- Reload Firewall port
reload = resource.shell.new("re-load")
reload.command = "firewall-cmd --reload"

-- Start rabbitmq server
start = resource.shell.new("start")
start.command = "systemctl start rabbitmq-server"

-- Access rabbitmq management console
web = resource.shell.new("web_ui")
web.command = "rabbitmq-plugins enable rabbitmq_management"

-- Change ownership for rabbitmq folder
owner = resource.shell.new("change_owner")
owner.command = "chown -R rabbitmq:rabbitmq /var/lib/rabbitmq"

-- Create user to access RabbitMQ console
adduser = resource.shell.new("add_user")
adduser.command = "rabbitmqctl add_user VirtEngine VirtEngine"

-- Add adminstrator tag for new user
addtag = resource.shell.new("add_tag")
addtag.command = "rabbitmqctl set_user_tags VirtEngine administrator"

-- To see web interface
print("See web interface using http://ipaddress:15672")

-- Finally, register the resources to the catalog
catalog:add(arc, key, des, port, reload, start, web, owner, adduser, addtag)
