-- Gru module for installing and configuring cassandra
--The require command respresents the serially execute the process.
--

-- get a attribute
f = loadfile("/var/lib/megam/gru/gulp/param.lua")
f()

gru_dir = "/var/lib/megam/gru/site/cassandra/script/"


-- Change mode for script file

mode = resource.shell.new("mode")
mode.command = "chmod 755 " .. gru_dir .. "cassandra.sh"

-- UPdate repository
upd = resource.shell.new("update_repo")
upd.command = "yum -y update"
upd.require = {
mode:ID(),
}

-- Installing java
inj = resource.shell.new("install_java")
inj.command ="yum -y install java"
inj.require = {
upd:ID(),
}

-- Creating repository
init = resource.shell.new("create_repository")
init.command = gru_dir .. "cassandra.sh"
init.require = {
  inj:ID(),
}


-- Finally, register the resources to the catalog
catalog:add(mode,upd,inj,init)


