#!/bin/bash

set -eou pipefail

download "http://ftpmirror.gnu.org/gnu/sed/sed-${sed}.tar.xz"

../configure \
    --prefix=${TOOLCHAIN}
make -j $(nproc)
make install
