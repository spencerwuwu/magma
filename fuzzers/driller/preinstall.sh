#!/bin/bash
set -xe

# For native AFL
apt-get update && \
    apt-get install -y make build-essential clang-9 git wget

update-alternatives \
  --install /usr/lib/llvm              llvm             /usr/lib/llvm-9  20 \
  --slave   /usr/bin/llvm-config       llvm-config      /usr/bin/llvm-config-9  \
    --slave   /usr/bin/llvm-ar           llvm-ar          /usr/bin/llvm-ar-9 \
    --slave   /usr/bin/llvm-as           llvm-as          /usr/bin/llvm-as-9 \
    --slave   /usr/bin/llvm-bcanalyzer   llvm-bcanalyzer  /usr/bin/llvm-bcanalyzer-9 \
    --slave   /usr/bin/llvm-c-test       llvm-c-test      /usr/bin/llvm-c-test-9 \
    --slave   /usr/bin/llvm-cov          llvm-cov         /usr/bin/llvm-cov-9 \
    --slave   /usr/bin/llvm-diff         llvm-diff        /usr/bin/llvm-diff-9 \
    --slave   /usr/bin/llvm-dis          llvm-dis         /usr/bin/llvm-dis-9 \
    --slave   /usr/bin/llvm-dwarfdump    llvm-dwarfdump   /usr/bin/llvm-dwarfdump-9 \
    --slave   /usr/bin/llvm-extract      llvm-extract     /usr/bin/llvm-extract-9 \
    --slave   /usr/bin/llvm-link         llvm-link        /usr/bin/llvm-link-9 \
    --slave   /usr/bin/llvm-mc           llvm-mc          /usr/bin/llvm-mc-9 \
    --slave   /usr/bin/llvm-nm           llvm-nm          /usr/bin/llvm-nm-9 \
    --slave   /usr/bin/llvm-objdump      llvm-objdump     /usr/bin/llvm-objdump-9 \
    --slave   /usr/bin/llvm-ranlib       llvm-ranlib      /usr/bin/llvm-ranlib-9 \
    --slave   /usr/bin/llvm-readobj      llvm-readobj     /usr/bin/llvm-readobj-9 \
    --slave   /usr/bin/llvm-rtdyld       llvm-rtdyld      /usr/bin/llvm-rtdyld-9 \
    --slave   /usr/bin/llvm-size         llvm-size        /usr/bin/llvm-size-9 \
    --slave   /usr/bin/llvm-stress       llvm-stress      /usr/bin/llvm-stress-9 \
    --slave   /usr/bin/llvm-symbolizer   llvm-symbolizer  /usr/bin/llvm-symbolizer-9 \
    --slave   /usr/bin/llvm-tblgen       llvm-tblgen      /usr/bin/llvm-tblgen-9

update-alternatives \
  --install /usr/bin/clang                 clang                  /usr/bin/clang-9     20 \
  --slave   /usr/bin/clang++               clang++                /usr/bin/clang++-9 \
  --slave   /usr/bin/clang-cpp             clang-cpp              /usr/bin/clang-cpp-9

# Install Driller & shellphish fuzzer
apt-get install -y gcc-multilib libtool automake autoconf bison debootstrap debian-archive-keyring libtool-bin lsb-release

sudo cp /etc/apt/sources.list /etc/apt/sources.list~
sudo sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list
apt-get update
apt-get build-dep -y qemu

apt-get install -y python3 python3-dev python3-pip
pip3 install --upgrade pip
pip3 install setuptools

# Install Shellphish Fuzzer
git clone --depth 1 https://github.com/shellphish/shellphish-afl
pushd shellphish-afl
python3 setup.py develop
cp -r bin/* /usr/bin/
popd
git clone https://github.com/shellphish/fuzzer
patch -p1 -d "fuzzer" < "$FUZZER/shellphuzz.patch"
pushd fuzzer
pip3 install -r reqs.txt
python3 setup.py install
popd

# Install Driller
pip3 install git+https://github.com/angr/tracer
pip3 install git+https://github.com/shellphish/driller
