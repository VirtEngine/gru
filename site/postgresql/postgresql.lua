--
-- Gru module for installing and configuring memcached
--

-- Install postgresql package

pkg1 = resource.package.new("postgresql-server")
pkg1.state = "present"
pkg2 = resource.package.new("postgresql-contrib")
pkg2.state = "present"
pkg2.require = {
   pkg1:ID(),
}

-- Initialize postgresql database

arc = resource.shell.new("initialize")
arc.command = "/usr/bin/postgresql-setup initdb"
arc.require = {
   pkg2:ID(),
}

-- Start postgresql service

svc = resource.service.new("postgresql")
svc.state = "running"
svc.enable = true
svc.require = {
   arc:ID(),
}

-- To access postgresql

print("access postgresql using su  - postgres && psql")

-- Finally, register the resources to the catalog
catalog:add(pkg1, pkg2, arc, svc)
