download "http://ftpmirror.gnu.org/gnu/automake/automake-${automake}.tar.xz"
../configure \
    --prefix=${TOOLCHAIN}
make -j $(nproc)
make install
