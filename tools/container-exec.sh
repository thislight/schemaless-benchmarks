#!/bin/sh

zig build benchmark &&\
make results &&\
cp results.md results.csv results-extended.md /opt
