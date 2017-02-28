-- Gru module for installing and configuring mysql
--

-- wget riak package
arc = resource.shell.new("cd /var/lib")
arc.command = "wget -O /var/lib/riak-2.1.3-1.el6.x86_64.rpm http://s3.amazonaws.com/downloads.basho.com/riak/2.1/2.1.3/rhel/6/riak-2.1.3-1.el6.x86_64.rpm"

-- install riak rpm package
des = resource.shell.new("des")
des.command = "rpm -ivh /var/lib/riak-2.1.3-1.el6.x86_64.rpm"

print("check riak installation using riak ping ")

-- Finally, register the resources to the catalog
catalog:add(arc, des)
