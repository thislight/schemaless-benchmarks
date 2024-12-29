
CPU model: AMD Ryzen 5 4600U with Radeon Graphics  
Bogomips: 4192.20
Sun, 29 Dec 2024 15:34:57 +0000
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
| [hash-data.c][hash-data] | 1.22 ± 1.22 | 35336 | subtracted from Write tests |
| [hash-object.c][hash-object] | 1.47 ± 1.47 | 36184 | subtracted from Tree and Incremental tests |


_The Time column shows the total time taken to hash the expected output of the library in the test (the expected objects for Tree and Incremental tests, or a chunk of bytes roughly the size of encoded data for the Write tests.) The Code Size column shows the total code size of the benchmark harness, including object generation code (which is included in all tests.)_



### Write Test

| Library | Format | Time<br>(μs) | Code Size<br>(bytes) ▲ | Time<br>Overhead | Hash |
|----|----|---:|---:|---:|---:|
| [Zigpak][zigpak] (0.3.0) [(Zig)][zigpak-write] | MessagePack | 13.23 ± 14.51 | 3704 | 11.81 ± 16.70 | bcfb74f1 |
| [MPack][mpack] (0.8.1) [(C)][mpack-write] | MessagePack | 2.92 ± 4.32 | 43720 | 3.39 ± 4.79 | 1a9c6681 |
| [MPack][mpack] (0.8.1) \[tracking] [(C)][mpack-tracking-write] | MessagePack | 6.20 ± 7.52 | 48504 | 6.06 ± 8.57 | 1a9c6681 |



_The Time and Code Size columns show the net result after subtracting the hash-data time and size. The Time Overhead column shows the total time of the benchmark divided by the total time of hash-data. In all three columns, lower is better._



### Tree Test

| Library | Format | Time<br>(μs) | Code Size<br>(bytes) ▲ | Time<br>Overhead | Hash |
|----|----|---:|---:|---:|---:|
| [MPack][mpack] (0.8.1) [(C)][mpack-node] | MessagePack | 16.99 ± 18.52 | 43304 | 12.55 ± 17.74 | 0075ff81 |
| [MPack][mpack] (0.8.1) \[UTF-8] [(C)][mpack-utf8-node] | MessagePack | 19.42 ± 20.94 | 43416 | 14.20 ± 20.08 | 0075ff81 |



_The Time and Code Size columns show the net result after subtracting the hash-object time and size. The Time Overhead column shows the total time of the benchmark divided by the total time of hash-object. In all three columns, lower is better._



### Incremental Parse Test

| Library | Format | Time<br>(μs) | Code Size<br>(bytes) ▲ | Time<br>Overhead | Hash |
|----|----|---:|---:|---:|---:|
| [Zigpak][zigpak] (0.3.0) [(Zig)][zigpak-read] | MessagePack | 6.46 ± 8.07 | 4568 | 5.39 ± 7.62 | 07d6c601 |
| [MPack][mpack] (0.8.1) [(C)][mpack-read] | MessagePack | 5.22 ± 6.85 | 42968 | 4.55 ± 6.43 | 0075ff81 |
| [MPack][mpack] (0.8.1) \[UTF-8] [(C)][mpack-utf8-read] | MessagePack | 7.28 ± 8.87 | 42968 | 5.95 ± 8.41 | 0075ff81 |
| [MPack][mpack] (0.8.1) \[tracking] [(C)][mpack-tracking-read] | MessagePack | 7.55 ± 9.14 | 47816 | 6.13 ± 8.67 | 0075ff81 |



_The Time and Code Size columns show the net result after subtracting the hash-object time and size. The Time Overhead column shows the total time of the benchmark divided by the total time of hash-object. In all three columns, lower is better._


