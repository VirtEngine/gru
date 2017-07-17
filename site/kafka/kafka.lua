--
-- Gru module for installing and configuring kafka
-- The require command respresents the serially execute the process.
--

-- get a attribute
f = loadfile("/root/gru/gulp/param.lua")
f()
gru_dir = "/root/gru/site/kafka/script/"

-- Change mode for script file.

mode = resource.shell.new("mode")
mode.command = "chmod 755 " .. gru_dir .. "kafka.sh"

-- Run the script file.

init = resource.shell.new("install_kafka")
init.command = gru_dir .. "kafka.sh"
init.require = {
  mode:ID(),
}

-- Finally, register the resources to the catalog
catalog:add(mode, init)

