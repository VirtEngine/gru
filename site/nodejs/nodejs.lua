--
-- Gru module for installing and configuring couchdb
-- The require command respresents the serially execute the process.
--

dir = "/var/lib/megam/"

m = loadfile(dir .. "gru/site/buildpacks/buildpacks.lua")
m()
