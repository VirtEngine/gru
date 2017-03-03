-- Gru module for installing and configuring mysql
--
-- Wget riak package.
arc = resource.shell.new("download")
arc.command = "wget -O /var/lib/riak-2.1.3-1.el6.x86_64.rpm http://s3.amazonaws.com/downloads.basho.com/riak/2.1/2.1.3/rhel/6/riak-2.1.3-1.el6.x86_64.rpm"
-- Install riak rpm package..
des = resource.shell.new("install")
des.command = "rpm -ivh /var/lib/riak-2.1.3-1.el6.x86_64.rpm"
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
