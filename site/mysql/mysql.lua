--
-- Gru module for installing and configuring mysql
--

-- Manage the memcached package
f = loadfile("gru/gulp/param.lua")
f()
--foo(credentials.username)
print("%%%%%%%%%%%%%%%%%%%%%%%55")
print(credentials.password)


arc = resource.shell.new("cd /var/lib")
arc.command = "wget -O /var/lib/mysql-community-release-el7-5.noarch.rpm http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm"

des = resource.shell.new("des")
des.command = "rpm -ivh /var/lib/mysql-community-release-el7-5.noarch.rpm"


print(credentials.pack)
pkg = resource.package.new(credentials.pack)
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
