#!/bin/bash

set -eou pipefail

download "http://ftpmirror.gnu.org/gnu/coreutils/coreutils-${coreutils}.tar.xz"

../configure \
    --prefix=${TOOLCHAIN} \
    --enable-install-program=hostname \
    FORCE_UNSAFE_CONFIGURE=1
make -j $(nproc)
make install
