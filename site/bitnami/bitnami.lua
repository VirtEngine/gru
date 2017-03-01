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
mode.command = "chmod 755 " .. bitnami_dir

exe = resource.shell.new("sh")
exe.command = bitnami_dir  ..   bitnami_url  


src = resource.shell.new("db")

if bitnami_database_password then

src.command = bitnami_file .. " --mode unattended  --base_user " .. bitnami_username  .. " --base_password " .. bitnami_password .. " --base_mail " .. bitnami_email .. " --database_root_password " .. bitnami_database_password

elseif bitnami_prestashop_site then

src.command = bitnami_file .. " --mode unattended  --base_user " .. bitnami_username  .. " --base_password " .. bitnami_password ..  " --base_mail " .. bitnami_email  .. " --prestashop_site " .. bitnami_prestashop_site

elseif bitnami_owncloud_site then

src.command = bitnami_file  .. " --mode unattended  --base_user " .. bitnami_username .. " --base_password " .. bitnami_password .. " --base_mail " .. bitnami_email  .. " --ownCloud_site " .. bitnami_owncloud_site

else

src.command = bitnami_file  .. " --mode unattended  --base_user " .. bitnami_username .. " --base_password " .. bitnami_password ..  " --base_mail " .. bitnami_email

end

-- Finally, register the resources to the catalog
catalog:add( mode, exe, src)
