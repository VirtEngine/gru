--
-- Gru module for installing and configuring bitnami
--

-- pass parameter

f = loadfile("gru/gulp/param.lua")
f()

bitnami_dir = "/var/lib/megam/bitnami/"
bitnami_file = "/var/lib/megam/bitnami/bitnami-run"

-- create bitnami  directory

dir = io.open(bitnami_file, "r")

if dir ~= nil then
bit_dir = resource.shell.new(bitnami_dir)
 bit_dir.command = "rm -rf" .. bitnami_dir
end

 bit_dir = resource.directory.new(bitnami_dir)
 bit_dir.state = "present"

--get a file from remote repository

remote = resource.shell.new("remote")
remote.command = "wget -O /var/lib/megam/bitnami/bitnami-run  " .. bitnami_url

--change permission of file
mode = resource.shell.new("mode")
mode.command = "chmod 755 " .. bitnami_file

if bitnami_database_password then
src = resource.shell.new("db")
src.command = bitnami_file .. " --mode unattended  --base_user " .. bitnami_username  .. " --base_password " .. bitnami_password .. " --base_mail " .. bitnami_email .. " --database_root_password " .. bitnami_database_password

elseif bitnami_prestashop_site then

src = resource.shell.new("db")
src.command = bitnami_file .. " --mode unattended  --base_user " .. bitnami_username  .. " --base_password " .. bitnami_password ..  " --base_mail " .. bitnami_email  .. " --prestashop_site " .. bitnami_prestashop_site

elseif bitnami_owncloud_site then

src = resource.shell.new("db")
src.command = bitnami_file  .. " --mode unattended  --base_user " .. bitnami_username .. " --base_password " .. bitnami_password .. " --base_mail " .. bitnami_email  .. " --ownCloud_site " .. bitnami_owncloud_site

else

src = resource.shell.new("db")
src.command = bitnami_file  .. " --mode unattended  --base_user " .. bitnami_username .. " --base_password " .. bitnami_password ..  " --base_mail " .. bitnami_email

end

-- Finally, register the resources to the catalog
catalog:add(bit_dir, remote, mode, src)
