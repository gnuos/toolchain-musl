#!/bin/bash

set -eou pipefail

download "http://ftpmirror.gnu.org/gnu/diffutils/diffutils-${diffutils}.tar.xz"

../configure \
    --prefix=${TOOLCHAIN}
make -j $(nproc)
make install
