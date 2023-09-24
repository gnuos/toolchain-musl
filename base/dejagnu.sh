#!/bin/bash

set -eou pipefail

download "http://ftpmirror.gnu.org/gnu/dejagnu/dejagnu-${dejagnu}.tar.gz"

../configure \
    --prefix=${TOOLCHAIN}
make install
