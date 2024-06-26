#!/bin/bash
# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* ./build-aux

./configure \
    --prefix=$PREFIX \
    --disable-dependency-tracking \
    --mandir=$PREFIX/share/man \
    --infodir=$PREFIX/share/info \
    || (cat config.log; false)


make -j$CPU_COUNT
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
make check -j$CPU_COUNT
fi
make install
