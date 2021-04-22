#!/bin/bash
set -xe

apt-get update && \
    apt-get install -y make build-essential git wget clang


# Install QSYM fuzzer
git clone https://github.com/sojhal/qsym.git

pushd qsym
# disable ptrace_scope for PIN
#echo 0|sudo tee /proc/sys/kernel/yama/ptrace_scope

# install z3 and system deps
./setup.sh

# install using virtual env
# virtualenv venv
# source venv/bin/activate
pip install .
popd
