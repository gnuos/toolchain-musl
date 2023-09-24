#!/bin/bash

set -eou pipefail

download "https://cdn.kernel.org/pub/linux/utils/util-linux/v2.39/util-linux-${utilLinux}.tar.xz"

../configure \
    --prefix=${TOOLCHAIN} \
    --without-python \
    --disable-makeinstall-chown \
    --without-systemdsystemunitdir \
    --without-ncurses \
    PKG_CONFIG=""
make -j $(nproc)
make install
