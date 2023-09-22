#!/bin/sh

set -eou pipefail

export GOPATH=/go
export GO111MODULE=on

url="https://github.com/moby/moby/archive/refs/tags/v${moby}.tar.gz"

download "$url"



