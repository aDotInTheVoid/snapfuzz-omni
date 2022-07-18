#!/bin/bash
set -eoxu pipefail

nproc=$(nproc)

AFL_CFLAGS="-DNOAFFIN_BENCH=1 -DLONG_BENCH=1 -O3 -funroll-loops"

CFLAGS="$AFL_CFLAGS" make -C aflnet/ -j$nproc
CFLAGS="$AFL_CFLAGS" make -C aflnet/llvm_mode -j$nproc

cd snapfuzz
# TODO: This means we're not idempotent, which isn't ideal, but
# Fine in docker.
git apply ../87-debug-lookup.patch
mkdir build
cd build
if [[ ! -f Makefile ]]; then
	cmake .. -DCMAKE_BUILD_TYPE=RELEASE
fi

make -j$nproc
