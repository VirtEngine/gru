--
-- Gru module for installing and configuring mysql
--

-- get a attribute
f = loadfile("/var/lib/megam/gru/gulp/param.lua")
f()
gru_dir = "/var/lib/megam/gru/site/rabbitmq/script/"

-- Change mode for script file.

mode = resource.shell.new("mode")
mode.command = "chmod 755 " .. gru_dir .. "rabbitmq.sh"

-- Run the script file.

init = resource.shell.new("install_RabbitMQ")
init.command = gru_dir .. "rabbitmq.sh " .. version
init.require = {
  mode:ID(),
}

-- To see web interface

print("See web interface using http://ipaddress:5984")
print("Admin user Credentials - VirtEngine & VirtEngine")

-- Finally, register the resources to the catalog
catalog:add(mode, init)
