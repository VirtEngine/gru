--
-- Gru module for installing and configuring java app
-- The require command respresents the serially execute the process.
--

dir = "/var/lib/megam/"

m = loadfile(dir .. "gru/site/buildpacks/buildpacks.lua")
m()
