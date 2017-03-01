--
-- Gru module for installing and configuring mysql
--

-- pass parameter
f = loadfile("/var/lib/megam/gru/gulp/param.lua")
f()

gru_dir = "/var/lib/megam/gru/site/couchdb/script/"

-- Change mode for script file.
mode = resource.shell.new("mode")
mode.command = "chmod 755 " ..  gru_dir .. "couchdb.sh"

-- Run the script file.
init = resource.shell.new("install_couchdb")
init.command = gru_dir .. "couchdb.sh " .. version

-- Enable Firewall port for access web interface
port = resource.shell.new("firewall")
port.command = "firewall-cmd --permanent --add-port=5984/tcp"

-- Reload Firewall port
reload = resource.shell.new("re-load")
reload.command = "firewall-cmd --reload"

-- Start CouchDB server
start = resource.shell.new("start")
start.command = "/usr/local/etc/rc.d/couchdb start"

-- To see web interface
print("See web interface using http://ipaddress:5984")

-- Finally, register the resources to the catalog
catalog:add(mode, init, port, reload, start)
