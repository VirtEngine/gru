-- Gru module for installing and configuring rethinkdb
--The require command respresents the serially execute the process.
--

-- get a attribute
f = loadfile("/root/gru/gulp/param.lua")
f()

gru_dir = "/root/gru/site/rethinkdb/script/"

-- Change mode for script file.

mode = resource.shell.new("mode")
mode.command = "chmod 755 " .. gru_dir .. "rethinkdb.sh"
-- Check version is empty.

--if (version == '') then
  version = '2.3.5'
--end

-- download repo
arc = resource.shell.new("download")
arc.command = "wget http://download.rethinkdb.com/centos/7/x86_64/rethinkdb.repo \
          -O /etc/yum.repos.d/rethinkdb.repo"
arc.require = {
mode:ID(),
}

-- install rethink
init = resource.shell.new("install")
init.command = "yum install -y rethinkdb"
init.require = {
arc:ID(),
}

-- install requirements
ins = resource.shell.new("install_requirements")
ins.command = "yum install -y openssl-devel libcurl-devel m4 git-core \
                 boost-static gcc-c++ npm ncurses-devel \
                 ncurses-static zlib-devel zlib-static"
ins.require = {
init:ID(),
}


-- install build dependencies

bd = resource.shell.new("install_build")
bd.command = "yum install -y protobuf-devel protobuf-static jemalloc-devel"
bd.require = {
ins:ID(),
}

-- install source code

sc = resource.shell.new("install_source")
sc.command = "wget http://download.rethinkdb.com/dist/rethinkdb-" .. version .. ".tgz"
sc.require = {
bd:ID(),
}


-- extract source code

ex =resource.shell.new("extract resource")
ex.command = "tar xf rethinkdb-" .. version ..  ".tgz"
ex.require = {
sc:ID(),
}


-- build rethinkdb 
rsh = resource.shell.new("run_script")
rsh.command = gru_dir .. "rethinkdb.sh " .. version
rsh.require = {
  sc:ID(),
}


-- Finally, register the resources to the catalog
catalog:add(mode,arc,init,ins,bd,sc,ex,rsh)

