download http://ftpmirror.gnu.org/gnu/binutils/binutils-${binutils}.tar.xz

../configure \
    --build=${HOST} \
    --host=${HOST} \
    --target=${TARGET} \
    --prefix=${TOOLCHAIN} \
    --with-sysroot=${SYSROOT} \
    --with-lib-path=${TOOLCHAIN}/lib \
    --disable-nls \
    --disable-werror
make -j $(nproc)
make install
