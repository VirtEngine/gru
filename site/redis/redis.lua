--
-- Gru module for installing and configuring memcached
--

-- Install Redis package
pkg = resource.package.new("redis")
pkg.state = "present"

-- Start Redis service
svc = resource.service.new("redis")
svc.state = "running"
svc.enable = true
svc.require = {
   pkg:ID(),

}

-- To access Redis
print("access redis using redis-cli")

-- Finally, register the resources to the catalog
catalog:add(pkg, systemd_reload, svc)
