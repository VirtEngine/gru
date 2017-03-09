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

--change permission of file

mode = resource.shell.new("mode")
mode.state = "present"
mode.command = "chmod 755 " .. gru_dir .. "package.sh "

--execute a script file

json = resource.shell.new("json")
json.state = "present"
json.command = "sh " .. gru_dir .. "package.sh " .. version .. tosca_type  .. scm
json.require = {
  mode:ID(),
}

--install buildpacks

packs = resource.shell.new("installbuildpackage")
packs.state = "present"
packs.command = "sh " .. gru_dir .. "install-buildpacks.sh " .. scm
packs.require = {
  json:ID(),
}

--install and run build

build = resource.shell.new("build")
build.state = "present"

if tosca_type == "nodejs" then
  build.command = "sh " .. gru_dir .. "build.sh " .. " /var/lib/megam/buildpacks/heroku-buildpack-nodejs.git " .. tosca_type .. scm
  build.require = {
    packs:ID(),
  }

elseif tosca_type == "java" then
  build.command = "sh " .. gru_dir .. "build.sh" .. " /var/lib/megam/buildpacks/heroku-buildpack-java.git " .. tosca_type .. scm
  build.require = {
    packs:ID(),
  }
  tomcat = resource.shell.new("tomcat")
  tomcat.state = "present"
  tomcat.command = "sh " .. gru_dir .. "java.sh"
  tomcat.require = {
    build:ID(),
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
catalog:add(mode, json, packs, build, tomcat)
