f = loadfile("/var/lib/megam/gru/gulp/param.lua")
f()

gru_dir = "/var/lib/megam/gru/site/buildpacks/script/"

node_dir = "/var/lib/megam/build/.heroku/node/bin/"

build_dir = "/var/lib/megam/app"


mode = resource.shell.new("mode")
mode.state = "present"
mode.command  = "chmod 755 " ..  gru_dir .. "package "



json = resource.shell.new("json")
json.state = "present"
json.command = gru_dir .. "package " .. version  .. tosca_type
json.require = {
      mode:ID(),
      }

packs = resource.shell.new("installbuildpackage")
packs.state = "present"
packs.command = gru_dir .. "install-buildpacks "  ..  scm
packs.require = {
    json:ID(),
     }

build = resource.shell.new("build")
build.state = "present"

if tosca_type == "nodejs" then

  build.command = gru_dir .. "build.sh " .. " /var/lib/megam/buildpacks/heroku-buildpack-nodejs.git"
  build.require = {
  json:ID(),
   }

  node = resource.shell.new("node")
  node.state = "present"
  node.command = "cp " .. node_dir .. "node " ..  " /bin/"
  node.require = {
  build:ID(),
  }

  npm = resource.shell.new("npm")
  npm.state = "present"
  npm.command = "ln -s " .. node_dir  .. "../lib/node_modules/npm/bin/npm-cli.js" .. " /bin/npm"
  npm.require = {
  node:ID(),
  }

elseif tosca_type == "java" then

  build.command = gru_dir .. "build.sh" .. " /var/lib/megam/buildpacks/heroku-buildpack-java.git"

elseif tosca_type == "php" then

  build.command = gru_dir .. "build.sh" .. " /var/lib/megam/buildpacks/heroku-buildpack-php.git"

elseif tosca_type == "rails" then

   build.command = gru_dir .. "build.sh" .. " /var/lib/megam/buildpacks/heroku-buildpack-ruby.git"
elseif tosca_type == "play" then

 build.command = gru_dir .. "build.sh" .. " /var/lib/megam/buildpacks/heroku-buildpack-pay.git"

 else

   print("No tosca_type provided")

end

catalog:add(mode, json, packs, build, node, npm)
