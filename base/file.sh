#!/bin/bash

set -eou pipefail

download http://ftp.astron.com/pub/file/file-${file}.tar.gz

../configure \
    --prefix=${TOOLCHAIN}
make -j $(nproc)
make install
