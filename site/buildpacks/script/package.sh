scm=$1
app_dir=""

basename=`echo "${scm##*/}"`
delgit=`echo ${basename%.*}`
 if [[ $basename == *".git"* ]]; then
  app_dir=$delgit
 else
  app_dir=$basename
 fi

json_dir=/var/lib/megam/app/$app_dir
gru_dir=/var/lib/megam/gru/site/buildpacks/script/

yum install  -y git

yum install -y ruby

chmod 755 $gru_dir/install-buildpacks.sh

chmod 755 $gru_dir/build.sh

cp $gru_dir/forego /var/lib/megam/app/$app_dir
