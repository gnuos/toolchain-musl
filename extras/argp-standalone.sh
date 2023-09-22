download http://www.lysator.liu.se/~nisse/misc/argp-standalone-${argp}.tar.gz
cd ../

./configure \
    --prefix=${TOOLCHAIN} \
    --disable-static
make -j $(nproc)
cp -v libargp.a /toolchain/lib/
cp -v argp.h /toolchain/include/
