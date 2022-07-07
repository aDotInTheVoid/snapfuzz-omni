#!/bin/bash
set -eoxu pipefail

nproc=$(nproc)

make -C aflnet/ -j$nproc
make -C aflnet/llvm_mode -j$nproc

mkdir -p snapfuzz/build
cd snapfuzz/build
if [[ ! -f Makefile ]]; then
	cmake .. -DCMAKE_BUILD_TYPE=RELEASE
fi

make -j$nproc
