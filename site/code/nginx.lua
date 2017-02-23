--
-- Gru module for installing and configuring memcached
--

-- Manage the memcached package
pkg = resource.package.new("nginx")
pkg.state = "present"

-- Manage the memcached service
svc = resource.service.new("nginx")
svc.state = "running"
svc.enable = true
svc.require = {
   pkg:ID(),

}

-- Finally, register the resources to the catalog
catalog:add(pkg, systemd_reload, svc)
