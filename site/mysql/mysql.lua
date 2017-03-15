--
-- Gru module for installing and configuring mysql
-- The require command respresents the serially execute the process.
--

-- get a attribute.
dir = "/var/lib/megam/"
f = loadfile(dir .. "gru/gulp/param.lua")
f()

-- Wget MySQL package.

arc = resource.shell.new("get")
arc.command = "wget -O /var/lib/mysql-community-release-el7-5.noarch.rpm http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm"

-- Install MySQL services.

des = resource.shell.new("des")
des.command = "rpm -ivh /var/lib/mysql-community-release-el7-5.noarch.rpm"
des.require = {
  arc:ID(),
}

-- Start MySQL-server.

pkg = resource.package.new("mysql-server")
pkg.state = "present"
pkg.require = {
  des:ID(),
}

-- Manage mysqld service.

svc = resource.service.new("mysqld")
svc.state = "running"
svc.enable = true
svc.require = {
  pkg:ID(),
}

-- Finally, register the resources to the catalog
catalog:add(arc, des, pkg, svc)
