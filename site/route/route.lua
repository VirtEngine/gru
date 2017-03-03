dir = "/var/lib/megam/"
f = loadfile(dir .. "gru/gulp/param.lua")
f()
if tosca_type == "riak" then
 m = loadfile(dir .. "gru/site/riak/riak.lua")
 m()

elseif tosca_type == "redis" then
 m = loadfile(dir .. "gru/site/redis/redis.lua")
 m()

elseif tosca_type == "mysql" then
  m = loadfile(dir .. "gru/site/mysql/mysql.lua")
  m()

elseif tosca_type == "rabbitmq" then
   m = loadfile(dir .. "gru/site/rabbitmq/rabbitmq.lua")
   m()

elseif tosca_type == "postgresql" then
    m = loadfile(dir .. "gru/site/postgresql/postgresql.lua")
    m()

elseif tosca_type == "apache" then
    m = loadfile(dir .. "gru/site/apache/apache.lua")
    m()

elseif tosca_type == "bitnami" then
  m = loadfile(dir .. "gru/site/bitnami/bitnami.lua")
  m()

elseif tosca_type == "nodejs" then
  m = loadfile(dir .. "gru/site/buildpacks/buildpacks.lua")
  m()

elseif tosca_type == "couchdb" then
    m = loadfile(dir .. "gru/site/couchdb/couchdb.lua")
    m()

else
print("no tosca type selected")
end
