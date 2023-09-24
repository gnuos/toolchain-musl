#!/bin/bash

set -eou pipefail

download "http://ftpmirror.gnu.org/gnu/bash/bash-${bash}.tar.gz"

../configure \
    --prefix=${TOOLCHAIN} \
    --without-bash-malloc
make -j $(nproc)
make install
