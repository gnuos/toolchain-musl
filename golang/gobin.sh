download https://go.dev/dl/go${go}.linux-${ARCH}.tar.gz

tar -xzf go${golang}.linux-${ARCH}.tar.gz

export GOROOT_FINAL="$TOOLCHAIN/go"

mv -fu go "$GOROOT_FINAL"

