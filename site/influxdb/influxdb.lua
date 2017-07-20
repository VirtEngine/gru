--
-- Gru module for installing and configuring influxdb
-- The require command respresents the serially execute the process.
--

-- get a attribute
f = loadfile("/var/lib/megam/gru/gulp/param.lua")
f()
gru_dir = "/var/lib/megam/gru/site/influxdb/script/"

-- Change mode for script file.

mode = resource.shell.new("mode")
mode.command = "chmod 755 " .. gru_dir .. "influxdb.sh"

-- Run the script file.

init = resource.shell.new("install_repo")
init.command = gru_dir .. "influxdb.sh "
init.require = {
  mode:ID(),
}

-- installing influxdb
ins = resource.shell.new("install_influx")
ins.command = "yum install influxdb" 
ins.require = {
  init:ID(),
}

-- starting influxdb
str = resource.shell.new("starting")
str.command = "service influxdb start"
str.require = {
  ins:ID(),
}

-- Finally, register the resources to the catalog
catalog:add(mode,init,ins,str)
