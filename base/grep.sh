#!/bin/bash

set -eou pipefail

download "http://ftpmirror.gnu.org/gnu/grep/grep-${grep}.tar.xz"

../configure \
    --prefix=${TOOLCHAIN}
make -j $(nproc)
make install
