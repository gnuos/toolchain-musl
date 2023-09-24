#!/bin/bash

set -eo pipefail

download https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-${linuxKernel}.tar.xz

make -j $(nproc) -C ../ INSTALL_HDR_PATH=dest headers_install
cp -rv ../dest/include/* ${TOOLCHAIN}/include
