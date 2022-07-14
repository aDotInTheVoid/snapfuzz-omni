#!/bin/bash
set -eoxu pipefail

nproc=$(nproc)

make -C aflnet/ -j$nproc
make -C aflnet/llvm_mode -j$nproc

cd snapfuzz
git am ../87-debug-lookup.patch
cd build
if [[ ! -f Makefile ]]; then
	cmake .. -DCMAKE_BUILD_TYPE=RELEASE
fi

make -j$nproc
