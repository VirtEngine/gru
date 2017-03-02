-- pass parameter

f = loadfile("/var/lib/megam/gru/gulp/param.lua")
f()

gru_dir = "/var/lib/megam/gru/site/buildpacks/script/"

node_dir = "/var/lib/megam/build/.heroku/node/bin/"

build_dir = "/var/lib/megam/app"

git = resource.package.new("git")
git.state = "present"

mode = resource.shell.new("mode")
mode.command = "chmod 755 " ..  gru_dir .. "install-buildpacks "

per = resource.shell.new("permission")
per.command = "chmod 755 " ..  gru_dir .. "build.sh "

packs = resource.shell.new("installbuildpackage")
packs.command = gru_dir .. "install-buildpacks "  ..  scm

ruby = resource.package.new("ruby")
ruby.state = "present"

build = resource.shell.new("build")

if tosca_type == "nodejs" then
  packmode = resource.shell.new("packmode")
  packmode.command  = "chmod 755 " ..  grudir .. "package"

  json = resource.shell.new("json")
  json.command = grudir .. "package " .. version

  build.command = gru_dir .. "build.sh " .. " /var/lib/megam/buildpacks/heroku-buildpack-nodejs.git"
  node = resource.shell.new("node")
  node.command = "cp " .. node_dir .. "node " ..  " /bin/"
  npm = resource.shell.new("npm")
  npm.command = "ln -s " .. node_dir  .. "../lib/node_modules/npm/bin/npm-cli.js" .. " /bin/npm"

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

-- Finally, register the resources to the catalog
catalog:add(mode, per, packs, git, unit_dir, app,  build, packmode, json ,node, npm)
