--
-- Gru module for installing and configuring couchdb
-- The require command respresents the serially execute the process.
--

-- get a attribute
f = loadfile("/var/lib/megam/gru/gulp/param.lua")
f()
gru_dir = "/var/lib/megam/gru/site/subversion/script/"

-- Change mode for script file.

mode = resource.shell.new("mode")
mode.command = "chmod 755 " .. gru_dir .. "subversion.sh"

-- Run the script file.

init = resource.shell.new("install_subversion")
init.command = gru_dir .. "subversion.sh"
init.require = {
  mode:ID(),
}

-- To see in terminal

print("svn co <source url of any project>")

-- Finally, register the resources to the catalog
catalog:add(mode, init)

