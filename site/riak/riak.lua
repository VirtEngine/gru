-- Gru module for installing and configuring riak
--The require command respresents the serially execute the process.
--

-- get a attribute
f = loadfile("/var/lib/megam/gru/gulp/param.lua")
f()

-- Check version is empty.

if (version == '') then
  version = '2.2.0'
end

-- find repo version.

repo = string.sub(version, 1, -3)

-- Wget riak package.

arc = resource.shell.new("download")
arc.command = "wget -O /var/lib/riak-" .. version .. "-1.el6.x86_64.rpm http://s3.amazonaws.com/downloads.basho.com/riak/" .. repo .."/" .. version .. "/rhel/6/riak-" .. version .. "-1.el6.x86_64.rpm"

-- Install riak rpm package..

des = resource.shell.new("install")
des.command = "rpm -ivh /var/lib/riak-".. version .. "-1.el6.x86_64.rpm"
des.require = {
  arc:ID(),
}

-- Start the riak service.

start = resource.shell.new("start_riak")
start.command = "riak start"
start.require = {
  des:ID(),
}

print("check riak installation using riak ping ")

-- Finally, register the resources to the catalog
catalog:add(arc, des, start)
