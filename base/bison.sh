#!/bin/bash

set -eou pipefail

download "http://ftpmirror.gnu.org/gnu/bison/bison-${bison}.tar.xz"

../configure \
    --prefix=${TOOLCHAIN} \
    FORCE_UNSAFE_CONFIGURE=1
make -j $(nproc)
make install
