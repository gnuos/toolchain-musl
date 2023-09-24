#!/bin/bash

set -eou pipefail

download "http://ftpmirror.gnu.org/gnu/findutils/findutils-${findutils}.tar.xz"

../configure \
    --prefix=${TOOLCHAIN}
make -j $(nproc)
make install
