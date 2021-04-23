#!/bin/bash

##
# Pre-requirements:
# - env FUZZER: path to fuzzer work dir
# - env TARGET: path to target work dir
# - env OUT: path to directory where artifacts are stored
# - env SHARED: path to directory shared with host (to store results)
# - env PROGRAM: name of program to run (should be found in $OUT)
# - env ARGS: extra arguments to pass to the program
# - env FUZZARGS: extra arguments to pass to the fuzzer
##

mkdir -p "$SHARED/findings"

export AFL_SKIP_CPUFREQ=1
export AFL_NO_AFFINITY=1

# run AFL master
"$FUZZER/repo/afl-fuzz" -M afl-master -i $TARGET/corpus/$PROGRAM/ -o "$SHARED/findings" -- $OUT/$PROGRAM $ARGS 2>&1 &
sleep 30
# run QSYM
/qsym/bin/run_qsym_afl.py -a afl-master -o "$SHARED/findings" -n qsym -- $OUT_UN/$PROGRAM $ARGS 2>&1
