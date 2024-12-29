
CPU model: AMD Ryzen 5 4600U with Radeon Graphics  
Bogomips: 4192.20
Sun, 29 Dec 2024 14:42:26 +0000
0fe3c9d6f27d72149c14fad0b897255238644b62

[mpack]: https://github.com/ludocode/mpack
[cmp]: https://github.com/camgunz/cmp
[msgpack]: https://github.com/msgpack/msgpack-c
[rapidjson]: http://rapidjson.org/
[yajl]: http://lloyd.github.io/yajl/
[libbson]: https://github.com/mongodb/libbson
[binn]: https://github.com/liteserver/binn
[jansson]: http://www.digip.org/jansson/
[json-parser-lib]: https://github.com/udp/json-parser
[json-builder-lib]: https://github.com/udp/json-builder
[ubj]: https://github.com/Steve132/ubj
[mongo-cxx]: https://github.com/mongodb/mongo-cxx-driver
[zigpak]: https://github.com/thislight/zigpak

[hash-object]: https://github.com/ludocode/schemaless-benchmarks/blob/master//src/src/hash/hash-object.c
[hash-data]: https://github.com/ludocode/schemaless-benchmarks/blob/master//src/src/hash/hash-data.c
[mpack-write]: https://github.com/ludocode/schemaless-benchmarks/blob/master//src/src/mpack/mpack-write.c
[mpack-read]: https://github.com/ludocode/schemaless-benchmarks/blob/master//src/src/mpack/mpack-read.c
[mpack-node]: https://github.com/ludocode/schemaless-benchmarks/blob/master//src/src/mpack/mpack-node.c
[mpack-tracking-write]: https://github.com/ludocode/schemaless-benchmarks/blob/master//src/src/mpack/mpack-write.c
[mpack-tracking-read]: https://github.com/ludocode/schemaless-benchmarks/blob/master//src/src/mpack/mpack-read.c
[mpack-utf8-read]: https://github.com/ludocode/schemaless-benchmarks/blob/master//src/src/mpack/mpack-read.c
[mpack-utf8-node]: https://github.com/ludocode/schemaless-benchmarks/blob/master//src/src/mpack/mpack-node.c
[zigpak-read]: https://github.com/ludocode/schemaless-benchmarks/blob/master/src/zigpak/zigpak-read.zig
[zigpak-write]: https://github.com/ludocode/schemaless-benchmarks/blob/master/src/zigpak/zigpak-write.zig

## Small Data


### Hash Comparisons

| Benchmark | Time<br>(μs) | Code Size<br>(bytes) | Comparison |
|----|---:|---:|----|
| [hash-data.c][hash-data] | 1.23 | 38312 | subtracted from Write tests |
| [hash-object.c][hash-object] | 1.56 | 39288 | subtracted from Tree and Incremental tests |


_The Time column shows the total time taken to hash the expected output of the library in the test (the expected objects for Tree and Incremental tests, or a chunk of bytes roughly the size of encoded data for the Write tests.) The Code Size column shows the total code size of the benchmark harness, including hashing and object generation code (which is included in all tests.)_



### Write Test

| Library | Benchmark | Format | Time<br>(μs) ▲ | Code Size<br>(bytes) |
|----|----|----|---:|---:|
| [MPack][mpack] (0.8.1) | [mpack-write.c][mpack-write] | MessagePack | 3.06 | 64648 |
| [Zigpak][zigpak] (0.3.0) | [zigpak-write.zig][zigpak-write] | MessagePack | 9.81 | 3144 |



_The Time and Code Size columns show the net result after subtracting the hash-data time and size. In both columns, lower is better._



### Tree Test

| Library | Benchmark | Format | Time<br>(μs) ▲ | Code Size<br>(bytes) |
|----|----|----|---:|---:|
| [MPack][mpack] (0.8.1) | [mpack-node.c][mpack-node] | MessagePack | 15.96 | 64200 |



_The Time and Code Size columns show the net result after subtracting the hash-object time and size. In both columns, lower is better._



### Incremental Parse Test

| Library | Benchmark | Format | Time<br>(μs) ▲ | Code Size<br>(bytes) |
|----|----|----|---:|---:|
| [MPack][mpack] (0.8.1) | [mpack-read.c][mpack-read] | MessagePack | 3.73 | 63880 |
| [Zigpak][zigpak] (0.3.0) | [zigpak-read.zig][zigpak-read] | MessagePack | 5.52 | 5552 |



_The Time and Code Size columns show the net result after subtracting the hash-object time and size. In both columns, lower is better._


## Large Data


### Hash Comparisons

| Benchmark | Time<br>(μs) | Code Size<br>(bytes) | Comparison |
|----|---:|---:|----|
| [hash-data.c][hash-data] | 78.50 | 38312 | subtracted from Write tests |
| [hash-object.c][hash-object] | 349.18 | 39288 | subtracted from Tree and Incremental tests |


_The Time column shows the total time taken to hash the expected output of the library in the test (the expected objects for Tree and Incremental tests, or a chunk of bytes roughly the size of encoded data for the Write tests.) The Code Size column shows the total code size of the benchmark harness, including hashing and object generation code (which is included in all tests.)_



### Write Test

| Library | Benchmark | Format | Time<br>(μs) ▲ | Code Size<br>(bytes) |
|----|----|----|---:|---:|
| [MPack][mpack] (0.8.1) | [mpack-write.c][mpack-write] | MessagePack | 739.84 | 64648 |
| [Zigpak][zigpak] (0.3.0) | [zigpak-write.zig][zigpak-write] | MessagePack | 1594.47 | 3144 |



_The Time and Code Size columns show the net result after subtracting the hash-data time and size. In both columns, lower is better._



### Tree Test

| Library | Benchmark | Format | Time<br>(μs) ▲ | Code Size<br>(bytes) |
|----|----|----|---:|---:|
| [MPack][mpack] (0.8.1) | [mpack-node.c][mpack-node] | MessagePack | 818.27 | 64200 |



_The Time and Code Size columns show the net result after subtracting the hash-object time and size. In both columns, lower is better._



### Incremental Parse Test

| Library | Benchmark | Format | Time<br>(μs) ▲ | Code Size<br>(bytes) |
|----|----|----|---:|---:|
| [MPack][mpack] (0.8.1) | [mpack-read.c][mpack-read] | MessagePack | 315.12 | 63880 |
| [Zigpak][zigpak] (0.3.0) | [zigpak-read.zig][zigpak-read] | MessagePack | 335.69 | 5552 |



_The Time and Code Size columns show the net result after subtracting the hash-object time and size. In both columns, lower is better._

