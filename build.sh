#!/bin/bash
set -eoxu pipefail

nproc=$(nproc)

make -C aflnet/ -j$nproc
make -C aflnet/llvm_mode -j$nproc

cd snapfuzz
# TODO: This means we're not idempotent, which isn't ideal, but
# Fine in docker.
git apply ../87-debug-lookup.patch
git apply ../6-clock-nanosleep.patch

mkdir build
cd build
if [[ ! -f Makefile ]]; then
	cmake .. -DCMAKE_BUILD_TYPE=RELEASE
fi

make -j$nproc
