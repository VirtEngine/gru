f = loadfile("gru/gulp/param.lua")
f()
if tosca_type == "riak" then
 m = loadfile( "gru/site/riak/riak.lua")
 m()

elseif tosca_type == "redis" then
 m = loadfile("gru/site/redis/redis.lua")
 m()

elseif tosca_type == "mysql" then
  m = loadfile("gru/site/mysql/redis.lua")
  m()

elseif tosca_type == "rabitmq" then
   m = loadfile("gru/site/rabitmq/rabitmq.lua")
   m()

elseif tosca_type == "postgresql" then
    m = loadfile("gru/site/postgresql/postgresql.lua")
    m()

elseif tosca_type == "bitnami" then
  m = loadfile("gru/site/bitnami/bitnami.lua")
  m()

elseif tosca_type == "nodejs" then
  m = loadfile("gru/site/buildpacks/buildpacks.lua")
  m()

else
print("no tosca type selected")

end
