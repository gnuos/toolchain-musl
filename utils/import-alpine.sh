#!/bin/bash

alpine_cdn="https://dl-cdn.alpinelinux.org/alpine"
alpine_archs="x86_64 aarch64"

alpine_version=$(echo "${alpine}" | cut -f1,2 -d'.' )


get_rootfs_tar() {
    set -o errexit
    set -o pipefail
    local arch

    mkdir -p "${DIR}/alpine/tars/$alpine_version"

    for arch in $alpine_archs; do
        local target_arch

        if [ "$arch" == "x86_64" ]; then
            target_arch="amd64"
        elif [ "$arch" == "aarch64" ]; then
            target_arch="arm64"
        fi

        mkdir -p "${DIR}/alpine/tars/$alpine_version/$target_arch"

	local filename="alpine-minirootfs-${alpine}-${arch}.tar.gz"
        local rootfs_url="${alpine_cdn}/v${alpine_version}/releases/${arch}/${filename}"

        # Grab our root file system
        if ! wget -c -L -O \
            "${DIR}/alpine/tars/${alpine_version}/$target_arch/alpine.tar.gz" "$rootfs_url"; then
            echo "Failed to download rootfs file version ${alpine_version} for arch ${target_arch}"
	    return 1
        fi

        # Grab the signature for the file
        if ! wget -c -L -O \
            "${DIR}/alpine/tars/${alpine_version}/$target_arch/key.asc" "${rootfs_url}.asc"; then
            echo "Failed to download signature file version ${alpine_version} for arch ${target_arch}"
	    return 1
        fi

        # Validate the downloaded root file system
        if ! gpg --verify "${DIR}/alpine/tars/${alpine_version}/$target_arch/key.asc"\
            "${DIR}/alpine/tars/${alpine_version}/$target_arch/alpine.tar.gz"; then
            echo "GPG Verification Failed!  Exiting"
            exit 1
        fi
    done
}

build_alpine_image() {
    set -o errexit
    set -o pipefail

    for arch in $alpine_archs; do
        if [ "$arch" == "x86_64" ]; then
            target_arch="amd64"
        elif [ "$arch" == "aarch64" ]; then
            target_arch="arm64"
        fi

	local build_date=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

	mkdir -p "${DIR}/alpine/$target_arch"
        
        buildctl --addr ${BUILDKIT_HOST} \
            build --progress=plain --frontend=dockerfile.v0 \
            --output type=docker,dest=${DIR}/alpine/$target_arch/alpine-v${alpine}.tar,name=alpine-base:latest \
            --local context="${DIR}/alpine/tars/$alpine_version/$target_arch/" \
            --local dockerfile=${DIR}/alpine \
            --opt target=alpine-img \
            --opt platform=linux/${target_arch} \
            --opt build-arg:ALPINE_VERSION=$alpine \
            --opt build-arg:BUILD_DATE="${build_date}" \
            --opt build-arg:VERSION=$alpine_version

        docker load < "${DIR}/alpine/$target_arch/alpine-v${alpine}.tar"
    done
}

import_alpine() {
    curl -s https://alpinelinux.org/keys/ncopa.asc | gpg --import -

    get_rootfs_tar

    build_alpine_image

    buildctl --addr ${BUILDKIT_HOST} prune
    buildctl --addr ${BUILDKIT_HOST} prune-histories
}

