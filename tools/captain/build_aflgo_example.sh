#!/bin/bash -e
export FUZZER="aflgo"
export TARGET="libpng"
export BUG="AAH001"
export PROGRAM="libpng_read_fuzzer"
./build.sh
