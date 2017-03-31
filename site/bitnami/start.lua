f = loadfile("/var/lib/megam/gru/gulp/param.lua")
f()

et = loadfile("/var/lib/megam/gru/site/bitnami/etlua.lua")
et()

local template = et().compile([[

[Unit]
    Description=bitnami<%= bitnami_app %>
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
