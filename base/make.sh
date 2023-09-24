#!/bin/bash

set -eou pipefail

download "http://ftpmirror.gnu.org/gnu/make/make-${make}.tar.gz"

../configure \
    --prefix=${TOOLCHAIN} \
    --without-guile
make -j $(nproc)
make install
