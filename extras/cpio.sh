download "http://ftpmirror.gnu.org/gnu/cpio/cpio-${cpio}.tar.gz"

../configure \
    --prefix=${TOOLCHAIN}
make -j $(nproc)
make install
