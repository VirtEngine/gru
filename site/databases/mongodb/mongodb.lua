-- Gru module for installing and configuring mongodb
--The require command respresents the serially execute the process.
--

-- get a attribute
f = loadfile("/var/lib/megam/gru/gulp/param.lua")
f()

gru_dir = "/var/lib/megam/gru/site/mongodb/script/"


-- Adding the MongoDB Repository
-- Run the script file.

init = resource.shell.new("repo")
init.command = " sh " gru_dir .. "mongodb.sh " .. version

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
catalog:add(init,pkg,svc)

