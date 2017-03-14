--
-- Gru module for installing and configuring mysql
--

-- get a attribute

f = loadfile("/var/lib/megam/gru/gulp/param.lua")
f()

--declare a variable

gru_dir = "/var/lib/megam/gru/site/buildpacks/script/"

node_dir = "/var/lib/megam/build/.heroku/node/bin/"

build_dir = "/var/lib/megam/app"

--install buildpacks

packs = resource.shell.new("installbuildpackage")
packs.state = "present"
packs.command = "sh " .. gru_dir .. "install-buildpacks.sh " .. scm


json = resource.shell.new("json")
json.state = "present"
json.command = "sh " .. gru_dir .. "package.sh " .. version .. " " ..  tosca_type  .. " " ..  scm
json.require = {
  packs:ID(),
}

--install and run build

build = resource.shell.new("build")
build.state = "present"

if tosca_type == "nodejs" then
  build.command = "sh " .. gru_dir .. "build.sh " .. " /var/lib/megam/buildpacks/heroku-buildpack-nodejs.git " .. tosca_type  .. " " .. scm
  build.require = {
    json:ID(),
  }

elseif tosca_type == "java" then
  build.command = "sh " .. gru_dir .. "build.sh" .. " /var/lib/megam/buildpacks/heroku-buildpack-java.git " .. tosca_type .. " " ..  scm
  build.require = {
    json:ID(),
  }
elseif tosca_type == "php" then
  build.command = gru_dir .. "build.sh" .. " /var/lib/megam/buildpacks/heroku-buildpack-php.git"

elseif tosca_type == "rails" then
  build.command = gru_dir .. "build.sh" .. " /var/lib/megam/buildpacks/heroku-buildpack-ruby.git"

elseif tosca_type == "play" then
  build.command = gru_dir .. "build.sh" .. " /var/lib/megam/buildpacks/heroku-buildpack-pay.git"

else
  print("No tosca_type provided")

end
-- Finally, register the resources to the catalog
catalog:add(packs,json,build)
