--
-- Gru module for installing and configuring flink
-- The require command respresents the serially execute the process.
--

-- get a attribute
f = loadfile("/var/lib/megam/gru/gulp/param.lua")
f()
gru_dir = "/var/lib/megam/gru/site/flink/script/"

-- Change mode for script file.

mode = resource.shell.new("mode")
mode.command = "chmod 755 " .. gru_dir .. "flink.sh"

-- Run the script file.

init = resource.shell.new("install_flink")
init.command = gru_dir .. "flink.sh "
init.require = {
  mode:ID(),
}

-- Finally, register the resources to the catalog
catalog:add(mode, init)
