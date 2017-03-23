f = loadfile("/var/lib/megam/gru/gulp/param.lua")
f()


local etlua = require "etlua"

local template = etlua.compile([[

[Unit]
    Description=bitnami<%= appname %>
    After=syslog.target network.target
[Service]
    Type=forking
    ExecStart=/opt/<%= bitnami_app %>/ctlscript.sh start
    ExecStop=/opt/<%= bitnami_app %>/ctlscript.sh stop
 [Install]
    WantedBy=multi-user.target

]])

file = io.open("/etc/systemd/system/bitnami.service", "w")
file:write(tostring(template({
})))
file:close()
