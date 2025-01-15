#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

export CFLAGS="${CFLAGS} -Wno-implicit-function-declaration"

if [[ ${target_platform} == "linux-aarch64" || ${target_platform} == "linux-ppc64le" ]]; then
    sed -i '/tests\/time-max-rss.sh \\/d' Makefile.am
fi

autoreconf --force --verbose --install
./configure \
    --prefix=$PREFIX \
    --disable-dependency-tracking \
    --mandir=$PREFIX/share/man \
    --infodir=$PREFIX/share/info \
    || (cat config.log; false)

make -j$CPU_COUNT
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR:-}" != "" ]]; then
make check -j$CPU_COUNT
fi
make install
