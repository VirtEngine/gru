json_dir=/var/lib/megam/build/package.json
gru_dir=/var/lib/megam/gru/site/buildpacks/script/

version=" "
tosca_type=$1

if [ "$version" == "" ] ; then

 version="4.0"

fi

yum install  -y git

yum install -y ruby

chmod 755 $gru_dir/install-buildpacks
chmod 755 $gru_dir/build.sh
mkdir -p /var/lib/megam/build
if [ "$tosca_type" == "nodejs" ] ; then
cat > $json_dir << EOF

{
  "engines": {
    "node": "$version"
  },
  "scripts": {
  "start": "node_etherpad/bin/run.sh --root"
}
}
EOF
fi
