
CPU model: ARMv7 Processor rev 5 (v7l)
Bogomips: 48.00
Sun, 29 Dec 2024 15:08:27 +0000
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

[hash-object]: https://github.com/ludocode/schemaless-benchmarks/blob/master//root/schemaless-benchmarks/src/hash/hash-object.c
[hash-data]: https://github.com/ludocode/schemaless-benchmarks/blob/master//root/schemaless-benchmarks/src/hash/hash-data.c
[mpack-write]: https://github.com/ludocode/schemaless-benchmarks/blob/master//root/schemaless-benchmarks/src/mpack/mpack-write.c
[mpack-read]: https://github.com/ludocode/schemaless-benchmarks/blob/master//root/schemaless-benchmarks/src/mpack/mpack-read.c
[mpack-node]: https://github.com/ludocode/schemaless-benchmarks/blob/master//root/schemaless-benchmarks/src/mpack/mpack-node.c
[mpack-tracking-write]: https://github.com/ludocode/schemaless-benchmarks/blob/master//root/schemaless-benchmarks/src/mpack/mpack-write.c
[mpack-tracking-read]: https://github.com/ludocode/schemaless-benchmarks/blob/master//root/schemaless-benchmarks/src/mpack/mpack-read.c
[mpack-utf8-read]: https://github.com/ludocode/schemaless-benchmarks/blob/master//root/schemaless-benchmarks/src/mpack/mpack-read.c
[mpack-utf8-node]: https://github.com/ludocode/schemaless-benchmarks/blob/master//root/schemaless-benchmarks/src/mpack/mpack-node.c
[zigpak-read]: https://github.com/ludocode/schemaless-benchmarks/blob/master/src/zigpak/zigpak-read.zig
[zigpak-write]: https://github.com/ludocode/schemaless-benchmarks/blob/master/src/zigpak/zigpak-write.zig

## Small Data


### Hash Comparisons

| Benchmark | Time<br>(μs) | Code Size<br>(bytes) | Comparison |
|----|---:|---:|----|
| [hash-data.c][hash-data] | 6.41 ± 6.41 | 38900 | subtracted from Write tests |
| [hash-object.c][hash-object] | 19.14 ± 19.14 | 39652 | subtracted from Tree and Incremental tests |


_The Time column shows the total time taken to hash the expected output of the library in the test (the expected objects for Tree and Incremental tests, or a chunk of bytes roughly the size of encoded data for the Write tests.) The Code Size column shows the total code size of the benchmark harness, including object generation code (which is included in all tests.)_



### Write Test

| Library | Format | Time<br>(μs) | Code Size<br>(bytes) ▲ | Time<br>Overhead | Hash |
|----|----|---:|---:|---:|---:|
| [Zigpak][zigpak] (0.3.0) [(Zig)][zigpak-write] | MessagePack | 106.04 ± 112.64 | 3016 | 17.53 ± 24.80 | bcfb74f1 |
| [MPack][mpack] (0.8.1) [(C)][mpack-write] | MessagePack | 37.48 ± 44.36 | 41280 | 6.84 ± 9.68 | 1a9c6681 |
| [MPack][mpack] (0.8.1) \[tracking] [(C)][mpack-tracking-write] | MessagePack | 69.32 ± 76.01 | 45896 | 11.81 ± 16.70 | 1a9c6681 |



_The Time and Code Size columns show the net result after subtracting the hash-data time and size. The Time Overhead column shows the total time of the benchmark divided by the total time of hash-data. In all three columns, lower is better._



### Tree Test

| Library | Format | Time<br>(μs) | Code Size<br>(bytes) ▲ | Time<br>Overhead | Hash |
|----|----|---:|---:|---:|---:|
| [MPack][mpack] (0.8.1) [(C)][mpack-node] | MessagePack | 84.03 ± 104.93 | 41104 | 5.39 ± 7.62 | 0075ff81 |
| [MPack][mpack] (0.8.1) \[UTF-8] [(C)][mpack-utf8-node] | MessagePack | 111.25 ± 131.78 | 41240 | 6.81 ± 9.64 | 0075ff81 |



_The Time and Code Size columns show the net result after subtracting the hash-object time and size. The Time Overhead column shows the total time of the benchmark divided by the total time of hash-object. In all three columns, lower is better._



### Incremental Parse Test

| Library | Format | Time<br>(μs) | Code Size<br>(bytes) ▲ | Time<br>Overhead | Hash |
|----|----|---:|---:|---:|---:|
| [Zigpak][zigpak] (0.3.0) [(Zig)][zigpak-read] | MessagePack | 56.09 ± 77.63 | 3976 | 3.93 ± 5.56 | 07d6c601 |
| [MPack][mpack] (0.8.1) [(C)][mpack-read] | MessagePack | 45.09 ± 67.01 | 40768 | 3.36 ± 4.75 | 0075ff81 |
| [MPack][mpack] (0.8.1) \[UTF-8] [(C)][mpack-utf8-read] | MessagePack | 67.55 ± 88.78 | 40768 | 4.53 ± 6.41 | 0075ff81 |
| [MPack][mpack] (0.8.1) \[tracking] [(C)][mpack-tracking-read] | MessagePack | 75.14 ± 96.20 | 45440 | 4.93 ± 6.97 | 0075ff81 |



_The Time and Code Size columns show the net result after subtracting the hash-object time and size. The Time Overhead column shows the total time of the benchmark divided by the total time of hash-object. In all three columns, lower is better._


