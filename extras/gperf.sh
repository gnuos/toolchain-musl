#!/bin/bash

set -eou pipefail

download "http://ftpmirror.gnu.org/gnu/gperf/gperf-${gperf}.tar.gz"

../configure \
    --prefix=${TOOLCHAIN}
make -j $(nproc)
make install
