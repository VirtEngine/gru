version=""
tosca_type=$1
scm=$2
app_dir=""

basename=`echo "${scm##*/}"`
delgit=`echo ${basename%.*}`
 if [[ $basename == *".git"* ]]; then
  app_dir=$delgit
 else
  app_dir=$basename
 fi

json_dir=/var/lib/megam/app/$app_dir/package.json
gru_dir=/var/lib/megam/gru/site/buildpacks/script/
if [ "$version" == "" ] ; then

 version="4.0"

fi

yum install  -y git

yum install -y ruby

chmod 755 $gru_dir/install-buildpacks.sh

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
cp -r  $json_dir /var/lib/megam/build
fi
