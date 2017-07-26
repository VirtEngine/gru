--
-- Gru module for installing and configuring mariadb
-- The require command respresents the serially execute the process.
--

-- get a attribute
f = loadfile("/var/lib/megam/gru/gulp/param.lua")
f()
gru_dir = "/var/lib/megam/gru/site/mariadb/script/"

-- Change mode for script file.

mode = resource.shell.new("mode")
mode.command = "chmod 755 " .. gru_dir .. "mariadb.sh"

-- Run the script file.

init = resource.shell.new("create_repository")
init.command = gru_dir .. "mariadb.sh"
init.require = {
  mode:ID(),
}


-- Finally, register the resources to the catalog
catalog:add(mode, init)
