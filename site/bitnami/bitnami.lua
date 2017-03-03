--
-- Gru module for installing and configuring bitnami
--

-- pass parameter

dir = "/var/lib/megam/"
f = loadfile(dir .. "gru/gulp/param.lua")
f()

bitnami_dir = "/var/lib/megam/gru/site/bitnami/remote.sh "
bitnami_file = "/var/lib/megam/bitnami/bitnami-run"

--change permission of file
mode = resource.shell.new("mode")
mode.state = "present"
mode.command = "chmod 755 " .. bitnami_dir

--execute and download bitnami file
exe = resource.shell.new("sh")
exe.command = bitnami_dir  ..   bitnami_url
exe.state = "present"
exe.require = {
   mode:ID(),
}

src = resource.shell.new("db")
src.state = "present"

if bitnami_database_password then
src.command = bitnami_file .. " --mode unattended  --base_user " .. bitnami_username  .. " --base_password " .. bitnami_password .. " --base_mail " .. bitnami_email .. " --database_root_password " .. bitnami_database_password
src.require = {
   exe:ID(),
}

elseif bitnami_prestashop_site then
src.command = bitnami_file .. " --mode unattended  --base_user " .. bitnami_username  .. " --base_password " .. bitnami_password ..  " --base_mail " .. bitnami_email  .. " --prestashop_site " .. bitnami_prestashop_site
src.require = {
   exe:ID(),
}

elseif bitnami_owncloud_site then
src.command = bitnami_file  .. " --mode unattended  --base_user " .. bitnami_username .. " --base_password " .. bitnami_password .. " --base_mail " .. bitnami_email  .. " --ownCloud_site " .. bitnami_owncloud_site
src.require = {
   exe:ID(),
}

else
src.command = bitnami_file  .. " --mode unattended  --base_user " .. bitnami_username .. " --base_password " .. bitnami_password ..  " --base_mail " .. bitnami_email
src.require = {
   exe:ID(),
}
end

-- Finally, register the resources to the catalog
catalog:add(mode, exe, src)
