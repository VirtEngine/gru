
-- Gru module for installing and configuring memcached
--The require command respresents the serially execute the process.
--

-- get a attribute
f = loadfile("/var/lib/megam/gru/gulp/param.lua")
f()

-- Check version is empty.

--if (version == '') then
  version = '1.4.39'
--end

gru_dir = "/root/gru/site/memcache/scripts/"

-- Change mode for script file.

mode = resource.shell.new("mode")
mode.command = "chmod 755 " .. gru_dir .. "memcache.sh"


-- install memcache

wgt = resource.shell.new("downloading")
wgt.command = "wget www.memcached.org/files/memcached-" .. version .. ".tar.gz"
wgt.require = {
mode:ID(),
}

-- untar package

utr = resource.shell.new("untar")
utr.command = "tar xvzf memcached-" .. version .. ".tar.gz"
utr.require = {
wgt:ID(),
}

rsh = resource.shell.new("change_directory")
rsh.state = "present"
rsh.command = gru_dir .. "memcache.sh"
rsh.require = {
utr:ID(),
}


-- Finally, register the resources to the catalog
catalog:add(mode,wgt,utr,rsh)
