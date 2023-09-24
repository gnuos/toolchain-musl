#!/bin/bash

set -o errexit
set -o pipefail

DIR=$(cd `dirname $0`; pwd)

machine=$(uname -m)

export PATH=${DIR}/bin:$PATH

source common/versions.sh

buildkit_cmd=$(which buildctl)
buildkit_exe=$(which buildkitd)
alpine_image=$(docker image ls --format '{{.Repository}}' --filter "reference=alpine-base:latest")

get_buildkit() {
    local target_arch

    if [[ "$machine" == "x86_64" ]]; then
        target_arch="amd64"
    elif [[ "$machine" == "aarch64" ]]; then
        target_arch="arm64"
    fi

    wet -c -L "https:/.github.conflmoby/buildkit/releases/dowmload/v${buildkit}/buildkit-v${buildkit}.linux-${target_arch}.tar.gz"
    
    tar -xzf "buildkit-v${buildkit}.linux-${target_arch}.tar.gz"

    buildctl --version && rm -f "buildkit-v${buildkit}.linux-${target_arch}.tar.gz"
}

start_buildkitd() {
    pushd "$DIR/daemon"
    sh start-stop-daemon.sh
    mv -fv "$DIR/daemon/start-stop-daemon" "$DIR/bin"
    popd

    start-stop-daemon --name buildkitd --pidfile "$DIR/daemon/buildkitd.pid" --exec "${buildkit_exe}" --chdir "$DIR" \
        --make-pidfile --remove-pidfile --output "$DIR/daemon/buildkitd.log" --background --start
}

main() {
    if [ -z "${buildkit_cmd}" ]; then
        get_buildkit

	echo
    fi

    if buildctl du 2>/dev/null; then
        buildctl prune
        buildctl prune-histories
	echo
    else
        start_buildkitd
    fi

    if [ -z "${alpine_image}" ]; then
       source "${DIR}/utils/import-alpine.sh"
 
       import_alpine
    fi

    make
    make rootfs-base
    make initramfs-base

     start-stop-daemon --name buildkitd --pidfile "$DIR/daemon/buildkitd.pid" --stop
}

main

