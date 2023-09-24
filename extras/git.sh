#!/bin/bash

set -eo pipefail

download "https://cdn.kernel.org/pub/software/scm/git/git-${git}.tar.xz"

cd ..
make configure
./configure \
    --prefix=${TOOLCHAIN}
make -j $(nproc)
make install
