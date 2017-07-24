--
-- Gru module for installing and configuring mantisbt
-- The require command respresents the serially execute the process.
--

-- get a attribute
f = loadfile("/var/lib/megam/gru/gulp/param.lua")
f()
gru_dir = "/var/lib/megam/gru/site/mantisbt/script/"

-- Change mode for script file.

mode = resource.shell.new("mode")
mode.command = "chmod 755 " .. gru_dir .. "mantisbt.sh"

-- Run the script file.

init = resource.shell.new("install_mantisbt")
init.command = gru_dir .. "mantisbt.sh"
init.require = {
  mode:ID(),
}

-- To see web interface

print("See web interface using http://ipaddress")

-- Finally, register the resources to the catalog
catalog:add(mode, init)

