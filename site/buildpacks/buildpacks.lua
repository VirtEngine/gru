-- pass parameter

f = loadfile("/var/lib/megam/gru/gulp/param.lua")
f()

gru_dir = "/var/lib/megam/gru/site/buildpacks/script/"

node_dir = "/var/lib/megam/build/.heroku/node/bin/"

build_dir = "/var/lib/megam/app"

mode = resource.shell.new("mode")
mode.command = "chmod 755 " ..  gru_dir .. "install-buildpacks "

per = resource.shell.new("permission")
per.command = "chmod 755 " ..  gru_dir .. "build.sh "

packs = resource.shell.new("install buildpackage")
packs.command = gru_dir .. "install-buildpacks"

git = resource.package.new("git")
git.state = "present"

unit_dir = resource.directory.new(build_dir)
unit_dir.state = "present"


app = resource.shell.new("app")
app.command = "git clone " .. scm

appname = {}
index = 1
for value in string.gmatch(scm,"%w+") do
    appname [index] = value
    index = index + 1
end
print(appname[5])


os.execute("mv " .. appname[5] .. "* " ..  build_dir )

ruby = resource.package.new("ruby")
ruby.state = "present"

build = resource.shell.new("build")

if tosca_type == "nodejs" then

  build.command = gru_dir .. "build.sh" .. " /var/lib/megam/buildpacks/heroku-buildpack-nodejs.git"
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
catalog:add(mode, per, packs, git, unit_dir, app,  build, node, npm)
