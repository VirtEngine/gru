--
-- Gru module for installing and configuring cockroachdb
-- The require command respresents the serially execute the process.
--

-- get a attribute
f = loadfile("/var/lib/megam/gru/gulp/param.lua")
f()

-- Check version is empty.

if (version == '') then
  version = '1.0.3'
end

-- Wget cockroachdb package

gck = resource.shell.new("download")
gck.command = "wget https://binaries.cockroachdb.com/cockroach-v" .. version .. ".linux-amd64.tgz"

-- untar package

utr = resource.shell.new("untar")
utr.command = "tar xfz cockroach-v" .. version .. ".linux-amd64.tgz"
utr.require = {
gck:ID(),
}


-- copy binary to path

cpy = resource.shell.new("copy")
cpy.command = "sudo cp -i cockroach-v" .. version .. ".linux-amd64/cockroach /usr/local/bin"
cpy.require = {
utr:ID(),
}

-- check version

cvr = resource.shell.new("check")
cvr.command = "cockroach version"
cvr.require = {
cpy:ID(),
}

-- Finally, register the resources to the catalog
catalog:add(gck,utr,cpy,cvr)
