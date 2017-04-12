set -eo pipefail

BUILDPACK_INSTALL_PATH="/var/lib/megam/buildpacks"
GIT_PATH="/var/lib/megam/app/"


download_buildpack() {
    buildpack_url="$1"
    buildpack_name=$(basename $buildpack_url)
    buildpack_commit="$2"

    echo "Fetching $buildpack_name..."
    set +e
    git clone --branch $buildpack_commit --depth 1 $buildpack_url $BUILDPACK_INSTALL_PATH/$buildpack_name &>/dev/null
    SHALLOW_CLONED=$?
    set -e
    if [ $SHALLOW_CLONED -ne 0 ]; then
        # if the shallow clone failed partway through, clean up and try a full clone
        rm -rf $BUILDPACK_INSTALL_PATH/$buildpack_name
        git clone --quiet $buildpack_url $BUILDPACK_INSTALL_PATH/$buildpack_name
        pushd $BUILDPACK_INSTALL_PATH/$buildpack_name &>/dev/null
            git checkout --quiet $buildpack_commit
        popd &>/dev/null
    fi

    echo "Done."
}

mkdir -p $BUILDPACK_INSTALL_PATH
mkdir -p $GIT_PATH

download_buildpack https://github.com/heroku/heroku-buildpack-multi.git          v1.0.0
download_buildpack https://github.com/heroku/heroku-buildpack-ruby.git           v155
download_buildpack https://github.com/heroku/heroku-buildpack-nodejs.git         v93
download_buildpack https://github.com/heroku/heroku-buildpack-java.git           v44
download_buildpack https://github.com/heroku/heroku-buildpack-gradle.git         v17
download_buildpack https://github.com/heroku/heroku-buildpack-grails.git         v21
download_buildpack https://github.com/heroku/heroku-buildpack-play.git           v26
download_buildpack https://github.com/heroku/heroku-buildpack-python.git         v97
download_buildpack https://github.com/megamsys/heroku-buildpack-php.git          
download_buildpack https://github.com/heroku/heroku-buildpack-clojure.git        v75
download_buildpack https://github.com/heroku/heroku-buildpack-scala.git          v72
download_buildpack https://github.com/heroku/heroku-buildpack-go.git             v54

cd $GIT_PATH
git clone $1
