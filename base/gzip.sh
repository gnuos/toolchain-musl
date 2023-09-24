#!/bin/bash

set -eou pipefail

download "http://ftpmirror.gnu.org/gnu/gzip/gzip-${gzip}.tar.xz"

../configure \
    --prefix=${TOOLCHAIN}
make -j $(nproc)
make install
