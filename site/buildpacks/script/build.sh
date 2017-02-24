#!/usr/bin/env bash
set -eo pipefail
echo $1

if [[ -f /etc/environment_proxy ]]; then
	source /etc/environment_proxy
fi

if [[ "$1" == "-" ]]; then
    slug_file="$1"
else
    slug_file=/tmp/slug.tgz
    if [[ "$1" ]]; then
        put_url="$1"
    fi
fi


app_dir=/app
build_root=/var/lib/megam/build
cache_root=/tmp/cache
buildpack_root=/var/lib/megam/buildpacks

mkdir -p $app_dir
mkdir -p $cache_root
mkdir -p $buildpack_root
mkdir -p $build_root/.profile.d
echo "*************************881*********"
echo $slug_file
function output_redirect() {
echo "***********************88822222222222"
echo $slug_file
    if [[ "$slug_file" == "-" ]]; then
        cat - 1>&2
    else
        cat -
    fi
}

function echo_title() {
  echo "****************************8823543"
    echo $'\e[1G----->' $* | output_redirect
}

function echo_normal() {
  echo "******************8844444444444"
    echo $'\e[1G      ' $* | output_redirect
}

function ensure_indent() {
    echo "******************88888555555555"
    while read line; do
        if [[ "$line" == --* ]]; then
            echo $'\e[1G'$line | output_redirect
        else
            echo $'\e[1G      ' "$line" | output_redirect
        fi
    done
}

## Copy application code over
echo "*************************886666666666"
if [ -d "/var/lib/megam/app" ]; then
    cp -rf /var/lib/megam/app/. $app_dir
   # chown -R slug:slug $app_dir
else
    cat | tar -xmC $app_dir
fi

# In heroku, there are two separate directories, and some
# buildpacks expect that.
echo "*********************************88777777777777777777"
cp -r $app_dir/. $build_root

## Buildpack fixes
echo "**************************888888888888888888888888"
export APP_DIR="$app_dir"
export HOME="$app_dir"
export REQUEST_ID=$(openssl rand -base64 32)
export STACK=cedar-14

## SSH key configuration

if [[ -n "$SSH_KEY" ]]; then
    mkdir -p ~/.ssh/
    chmod 700 ~/.ssh/

    echo $SSH_KEY | base64 -d > ~/.ssh/id_rsa
    chmod 400 ~/.ssh/id_rsa

    echo 'StrictHostKeyChecking=no' > ~/.ssh/config
    chmod 600 ~/.ssh/config
fi

## Buildpack detection
echo "************************999999999999999999999"
buildpacks=($buildpack_root/*)
echo $buildpacks

#selected_buildpack="/tmp/buildpacks/heroku-buildpack-nodejs.git"

selected_buildpack=$1

echo "*****************************810"
if [[ -n "$BUILDPACK_URL" ]]; then
    echo_title "Fetching custom buildpack"

    buildpack="$buildpack_root/custom"
    rm -fr "$buildpack"

    url=${BUILDPACK_URL%#*}
    committish=${BUILDPACK_URL#*#}

    if [ "$committish" == "$url" ]; then
        committish="master"
    fi

    set +e
    git clone --branch "$committish" --depth=1 "$url" "$buildpack" &> /dev/null
    SHALLOW_CLONED=$?
    set -e
    if [ $SHALLOW_CLONED -ne 0 ]; then
        # if the shallow clone failed partway through, clean up and try a full clone
        rm -rf "$buildpack"
        git clone --quiet "$url" "$buildpack"
        pushd "$buildpack" &>/dev/null
            git checkout --quiet "$committish"
            git submodule init --quiet
            git submodule update --quiet --recursive
        popd &>/dev/null
    fi

    selected_buildpack="$buildpack"
    buildpack_name=$($buildpack/bin/detect "$build_root") && selected_buildpack=$buildpack
else
    for buildpack in "${buildpacks[@]}"; do
        buildpack_name=$($buildpack/bin/detect "$build_root") && selected_buildpack=$buildpack && break
    done
fi

if [[ -n "$selected_buildpack" ]]; then
    echo_title "$buildpack_name app detected"
else
    echo_title "Unable to select a buildpack"
    exit 1
fi

export CURL_CONNECT_TIMEOUT="30"
export CURL_TIMEOUT="180"

## Buildpack compile
echo "**************#######################"
echo $selected_buildpack

$selected_buildpack/bin/compile "$build_root" "$cache_root" | ensure_indent

$selected_buildpack/bin/release "$build_root" "$cache_root" > $build_root/.release

## Display process types

echo_title "Discovering process types"
if [[ -f "$build_root/Procfile" ]]; then
    types=$(ruby -e "require 'yaml';puts YAML.load_file('$build_root/Procfile').keys().join(', ')")
    echo_normal "Procfile declares types -> $types"
fi
default_types=""
if [[ -s "$build_root/.release" ]]; then
    default_types=$(ruby -e "require 'yaml';puts (YAML.load_file('$build_root/.release')['default_process_types'] || {}).keys().join(', ')")
    [[ $default_types ]] && echo_normal "Default process types for $buildpack_name -> $default_types"
fi

# Fix any wayward permissions. We want everything in app to be owned
# by slug.
#chown -R slug:slug $build_root/*

## Produce slug

if [[ -f "$build_root/.slugignore" ]]; then
    tar -z --exclude='.git' -X "$build_root/.slugignore" -C $build_root -cf $slug_file . | cat
else
    tar -z --exclude='.git' -C $build_root -cf $slug_file . | cat
fi

if [[ "$slug_file" != "-" ]]; then
    slug_size=$(du -Sh "$slug_file" | cut -f1)
    echo_title "Compiled slug size is $slug_size"

    if [[ $put_url ]]; then
        curl -0 -s -o /dev/null -X PUT -T $slug_file "$put_url"
    fi
fi
