-- Gru module for installing and configuring scylla
--The require command respresents the serially execute the process.
--

-- get a attribute
f = loadfile("/var/lib/megam/gru/gulp/param.lua")
f()

gru_dir = "/var/lib/megam/gru/site/scylla/script/"

-- Change mode for script file.

mode = resource.shell.new("mode")
mode.command = "chmod 755 " .. gru_dir .. "scylla.sh"

-- Remove ABRT conflict
rem = resource.shell.new("remove")
rem.command = "yum remove -y abrt"
rem.require = {
mode:ID(),
}

-- Wget rpm 

pkg = resource.shell.new("downloading")
pkg.command = gru_dir .. "scylla.sh "
pkg.require = {
rem:ID(),
}

-- install scylla

init = resource.package.new("scylla")
init.state = "present"
init.require = {
pkg:ID(),
}

-- setup scyll

stp = resource.shell.new("setup")
stp.command = "/usr/lib/scylla/scylla_dev_mode_setup --developer-mode 1"
stp.require = {
init:ID(),
}

-- Start scylla service
svc = resource.service.new("scylla-server")
svc.state = "running"
svc.enable = true
svc.require = {
  stp:ID(),

}

-- Finally, register the resources to the catalog
catalog:add(mode,rem,pkg,init,svc,stp)
