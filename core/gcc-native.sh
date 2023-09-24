exportcross

download http://ftpmirror.gnu.org/gnu/mpfr/mpfr-${mpfr}.tar.xz mpfr
download http://ftpmirror.gnu.org/gnu/gmp/gmp-${gmp}.tar.xz gmp
download http://ftpmirror.gnu.org/gnu/mpc/mpc-${mpc}.tar.gz mpc
download http://ftpmirror.gnu.org/gnu/gcc/gcc-${gcc}/gcc-${gcc}.tar.xz

cat ../gcc/limitx.h ../gcc/glimits.h ../gcc/limity.h > `dirname $(${TARGET}-gcc -print-libgcc-file-name)`/include-fixed/limits.h

for file in ../gcc/config/{linux,i386/linux{,64}}.h; do
  cp -uv $file{,.orig}
  sed -e "s@/lib\(64\)\?\(32\)\?/ld@${TOOLCHAIN}&@g" \
      -e "s@/usr@${TOOLCHAIN}@g" $file.orig > $file
cat >> $file <<EOF
#undef STANDARD_STARTFILE_PREFIX_1
#undef STANDARD_STARTFILE_PREFIX_2
#define STANDARD_STARTFILE_PREFIX_1 "${TOOLCHAIN}/lib/"
#define STANDARD_STARTFILE_PREFIX_2 ""
EOF
  touch $file.orig
done

sed -e '/m64=/s/lib64/lib/' -i.orig ../gcc/config/i386/t-linux64

../configure \
    --build=${HOST} \
    --host=${HOST} \
    --prefix=${TOOLCHAIN} \
    --with-local-prefix=${TOOLCHAIN} \
    --with-native-system-header-dir=${TOOLCHAIN}/include \
    --disable-multilib \
    --disable-nls \
    --enable-shared \
    --enable-languages=c,c++ \
    --enable-__cxa_atexit \
    --enable-c99 \
    --enable-long-long \
    --enable-threads=posix \
    --enable-clocale=generic \
    --enable-libstdcxx-time \
    --enable-checking=release \
    --enable-fully-dynamic-string \
    --disable-symvers \
    --disable-gnu-indirect-function \
    --disable-libmudflap \
    --disable-libsanitizer \
    --disable-libmpx \
    --disable-lto-plugin \
    --disable-libssp \
    --disable-bootstrap
make -j $(nproc)
make install-strip
ln -sv gcc ${TOOLCHAIN}/bin/cc
echo 'int main(){}' > dummy.c
cc dummy.c
readelf -l a.out | grep ": ${TOOLCHAIN}"
