--
-- Gru module for installing and configuring customizing buildpacks app.
-- The require command respresents the serially execute the process.
--

-- get a attribute

f = loadfile("/var/lib/megam/gru/gulp/param.lua")
f()

--declare a variable

gru_dir = "/var/lib/megam/gru/site/buildpacks/script/"

--get download heroku buildpacks apps and clone the custom app from github

packs = resource.shell.new("installbuildpackage")
packs.state = "present"
packs.command = "sh " .. gru_dir .. "install-buildpacks.sh " .. scm

-- install ruby and basic require steps executed.
json = resource.shell.new("json")
json.state = "present"
json.command = "sh " .. gru_dir .. "package.sh "  ..  scm  .. " "  .. tosca_type
json.require = {
  packs:ID(),
}

--install the custom buildpacks app and start the procfile

build = resource.shell.new("build")
build.state = "present"

if tosca_type == "nodejs" then
  build.command = "sh " .. gru_dir .. "build.sh " .. " /var/lib/megam/buildpacks/heroku-buildpack-nodejs.git " .. tosca_type  .. " " .. scm

elseif tosca_type == "java" then
  build.command = "sh " .. gru_dir .. "build.sh" .. " /var/lib/megam/buildpacks/heroku-buildpack-java.git " .. tosca_type .. " " ..  scm

elseif tosca_type == "php" then
build.command = "sh " .. gru_dir .. "build.sh" .. " /var/lib/megam/buildpacks/heroku-buildpack-php.git " .. tosca_type .. " " ..  scm

elseif tosca_type == "rails" then
build.command = "sh " .. gru_dir .. "build.sh" .. " /var/lib/megam/buildpacks/heroku-buildpack-ruby.git " .. tosca_type .. " " ..  scm

elseif tosca_type == "play" then
  build.command = gru_dir .. "build.sh" .. " /var/lib/megam/buildpacks/heroku-buildpack-scala.git " .. tosca_type .. " " ..  scm

else
  print("No tosca_type provided")

end
build.require = {
  json:ID(),
}
-- Finally, register the resources to the catalog
catalog:add(packs,json,build)
