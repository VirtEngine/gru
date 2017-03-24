--
-- Gru module for installing and configuring bitnami
-- The require command respresents the serially execute the process.
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
exe.command = bitnami_dir .. bitnami_url
exe.state = "present"
exe.require = {
  mode:ID(),
}

src = resource.shell.new("db")
src.state = "present"

if bitnami_database_password then
  src.command = bitnami_file .. " --mode unattended --base_user " .. bitnami_username .. " --base_password " .. bitnami_password .. " --base_mail " .. bitnami_email .. " --database_root_password " .. bitnami_database_password

elseif bitnami_prestashop_site then
  src.command = bitnami_file .. " --mode unattended --base_user " .. bitnami_username .. " --base_password " .. bitnami_password .. " --base_mail " .. bitnami_email .. " --prestashop_site " .. bitnami_prestashop_site

elseif bitnami_owncloud_site then
  src.command = bitnami_file .. " --mode unattended --base_user " .. bitnami_username .. " --base_password " .. bitnami_password .. " --base_mail " .. bitnami_email .. " --ownCloud_site " .. bitnami_owncloud_site

else
  src.command = bitnami_file .. " --mode unattended --base_user " .. bitnami_username .. " --base_password " .. bitnami_password .. " --base_mail " .. bitnami_email

end

src.require = {
  exe:ID(),
}

bitsv = resource.shell.new("bitsv")
bitsv.state = "present"
bitsv.command = " lua /var/lib/megam/gru/site/bitnami/start.lua "
bitsv.require = {
src:ID(),
}
svc = resource.service.new("bitnami")
svc.state = "present"
svc.state = "running"
svc.enable = true
svc.require = {
   bitsv:ID(),
}
start = resource.shell.new("start")
start.state = "present"
start.command = " systemctl start bitnami "
start.require = {
svc:ID(),
}


-- Finally, register the resources to the catalog
catalog:add(mode, exe, src, bitsv, svc, start)
