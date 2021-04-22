#!/bin/bash
set -e

##
# Pre-requirements:
# - env FUZZER: path to fuzzer work dir
# - env TARGET: path to target work dir
# - env MAGMA: path to Magma support files
# - env OUT_UN: path to directory where artifacts are stored
# - env CFLAGS and CXXFLAGS must be set to link against Magma instrumentation
##

export CC="clang"
export CXX="clang++"
export AS="llvm-as"

export LIBS="$LIBS -l:driver.o -lstdc++"

export OUT=$OUT_UN
"$MAGMA/build.sh"
"$TARGET/build.sh"
