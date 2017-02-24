--
-- Gru module for installing and configuring memcached
--

-- Install apache httpd package
pkg = resource.package.new("httpd")
pkg.state = "present"

-- Start apache service
svc = resource.service.new("httpd")
svc.state = "running"
svc.enable = true
svc.require = {
   pkg:ID(),

}

-- To see web interface
print("see web ui using http://ipaddress")

-- Finally, register the resources to the catalog
catalog:add(pkg, systemd_reload, svc)
