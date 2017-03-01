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

exe = resource.shell.new("sh")
exe.command = bitnami_dir  ..   bitnami_url
exe.state = "present"


-- Finally, register the resources to the catalog
catalog:add(mode, exe)
