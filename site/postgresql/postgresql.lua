--
-- Gru module for installing and configuring memcached
--

-- Install postgresql package
pkg1 = resource.package.new("postgresql-server")
pkg1.state = "present"

pkg2 = resource.package.new("postgresql-contrib")
pkg2.state = "present"

-- Initialize postgresql database
arc = resource.shell.new("initialize")
arc.command = "/usr/bin/postgresql-setup initdb"

-- Start postgresql service
svc = resource.service.new("postgresql")
svc.state = "running"
svc.enable = true

-- To access postgresql
print("access postgresql using - postgres && psql")

-- Finally, register the resources to the catalog
catalog:add(pkg1, pkg2, arc, systemd_reload, svc)
