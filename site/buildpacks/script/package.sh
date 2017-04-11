scm=$1
app_dir=""
tosca_type=$2

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

if [[ $tosca_type == "php" ]]; then

  yum install bzip2-devel postgresql-libs-9.2.18-1.el7.i686 postgresql-devel

  ln -s /usr/lib64/libbz2.so.1.0.6 /usr/lib64/libbz2.so.1.0

  ln -s /usr/lib64/libpcre.so.1.2.0 /usr/lib64/libpcre.so.3

fi
