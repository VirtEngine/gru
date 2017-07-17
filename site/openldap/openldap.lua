-- Gru module for installing and configuring openldap
--The require command respresents the serially execute the process.
--

-- get a attribute
f = loadfile("/root/gru/gulp/param.lua")
f()

-- install openldap packages

init=resource.shell.new("install_ldap_packages")
init.command = "yum install -y openldap*"

-- starting ldap services

sts=resource.shell.new("start_ldap_services")
sts.command = "systemctl start slapd.service"
sts.require = {
init:ID(),
}

-- enabling ldap services

els=resource.shell.new("enabling_ldap_services")
els.command = "systemctl enable slapd.service"
els.require = {
sts:ID(),
}


-- Finally, register the resources to the catalog
catalog:add(init,sts,els)
