#!/bin/bash

set -o pipefail

DIR=$(cd `dirname $0`; pwd)

machine=$(uname -m)

export PATH=${DIR}/bin:$PATH
export BUILDKIT_HOST=docker-container://buildkitd

source common/versions.sh

buildkit_cmd=$(which buildctl)
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
    docker run -d --name buildkitd --privileged moby/buildkit:latest
}

main() {
    if [ -z "${buildkit_cmd}" ]; then
        get_buildkit

	echo
    fi

    if docker container ls -a --format '{{.Image}}' --filter "name=/buildkitd" | grep 'moby/buildkit' > /dev/null 2>&1; then
        buildctl --version

	echo
    else
        start_buildkitd
    fi

    if [ -z "${alpine_image}" ]; then
       source "${DIR}/utils/import-alpine.sh"
 
       import_alpine
    fi

    make
}

main

