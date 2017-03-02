f = loadfile("/var/lib/megam/gru/gulp/param.lua")
f()

gru_dir = "/var/lib/megam/gru/site/buildpacks/script/"

node_dir = "/var/lib/megam/build/.heroku/node/bin/"

build_dir = "/var/lib/megam/app"

git = resource.package.new("git")
git.state = "present"

catalog:add(git)

mode = resource.shell.new("mode")
mode.command = "chmod 755 " ..  gru_dir .. "install-buildpacks "
mode.require = { git:ID() }
catalog:add(mode)

per = resource.shell.new("permission")
per.command = "chmod 755 " ..  gru_dir .. "build.sh "
per.require = {  mode:ID() }

catalog:add(per)

packs = resource.shell.new("installbuildpackage")
packs.command = gru_dir .. "install-buildpacks "  ..  scm

packs.require = { per:ID() }


catalog:add(packs)

ruby = resource.package.new("ruby")
ruby.state = "present"

ruby.require = { packs:ID() }

catalog:add(ruby)

build = resource.shell.new("build")

if tosca_type == "nodejs" then
  packmode = resource.shell.new("packmode")
  packmode.command  = "chmod 755 " ..  gru_dir .. "package "
  packmode.require = { ruby:ID() }
 catalog:add(packmode)

  json = resource.shell.new("json")
  json.command = gru_dir .. "package " .. version
  json.require = { packmode:ID() }

catalog:add(json)

  build.command = gru_dir .. "build.sh " .. " /var/lib/megam/buildpacks/heroku-buildpack-nodejs.git"
  build.require = { json:ID() }
catalog:add(build)

  node = resource.shell.new("node")
  node.command = "cp " .. node_dir .. "node " ..  " /bin/"

catalog:add(node)
  npm = resource.shell.new("npm")
  npm.command = "ln -s " .. node_dir  .. "../lib/node_modules/npm/bin/npm-cli.js" .. " /bin/npm"

catalog:add(npm)
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
