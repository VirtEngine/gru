--
-- Gru module for installing and configuring mysql
--

-- get a attribute
dir = "/var/lib/megam/"
f = loadfile(dir .. "gru/gulp/param.lua")
f()

arc = resource.shell.new("get")
arc.command = "wget -O /var/lib/mysql-community-release-el7-5.noarch.rpm http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm"

des = resource.shell.new("des")
des.command = "rpm -ivh /var/lib/mysql-community-release-el7-5.noarch.rpm"

pkg = resource.package.new("mysql-server")
pkg.state = "present"

-- Manage the memcached service
svc = resource.service.new("mysqld")
svc.state = "running"
svc.enable = true
svc.require = {
   pkg:ID(),

}

-- Finally, register the resources to the catalog
catalog:add(arc, des, pkg, svc)
