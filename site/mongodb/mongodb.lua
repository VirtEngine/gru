-- Gru module for installing and configuring mongodb
--The require command respresents the serially execute the process.
--

-- get a attribute
f = loadfile("/var/lib/megam/gru/gulp/param.lua")
f()

gru_dir = "/var/lib/megam/gru/site/mongodb/script/"


-- Change mode for script file.

mode = resource.shell.new("mode")
mode.command = "chmod 755 " .. gru_dir .. "mongodb.sh"

-- Adding the MongoDB Repository
-- Run the script file.

init = resource.shell.new("repo")
init.command = " sh " gru_dir .. "mongodb.sh " .. version_mdb
init.require = {
  mode:ID(),
}

-- Install mongodb package

pkg = resource.package.new("mongodb-org")
pkg.state = "present"
pkg.require = {
 init:ID(),
}

-- Start mongodb service

svc = resource.service.new("mongod")
svc.state = "running"
svc.enable = true
svc.require = {
  pkg:ID(),

}


-- Finally, register the resources to the catalog
catalog:add(mode,init,pkg,svc)

