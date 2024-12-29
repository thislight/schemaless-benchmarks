#!/bin/sh

zig build benchmark -Doptimize=$1 -Dtarget=$2 &&\
test $1 != "Size" &&\
make results SIZE=$? &&\
mkdir -p /opt/$1 &&\
cp results.md results.csv results-extended.md /opt/$1
