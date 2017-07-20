--
-- Gru module for installing and configuring hadoop
-- The require command respresents the serially execute the process.
--

-- get a attribute
f = loadfile("/var/lib/megam/gru/gulp/param.lua")
f()
gru_dir = "/var/lib/megam/gru/site/hadoop/script/"

-- Change mode for script file.

mode = resource.shell.new("mode")
mode.command = "chmod 755 " .. gru_dir .. "hadoop.sh"

-- Run the script file.

init = resource.shell.new("install_hadoop")
init.command = gru_dir .. "hadoop.sh"
init.require = {
  mode:ID(),
}

-- Finally, register the resources to the catalog
catalog:add(mode, init)

