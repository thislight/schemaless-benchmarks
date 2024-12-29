
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
| [hash-data.c][hash-data] | 1.23 ± 1.23 | 38312 | subtracted from Write tests |
| [hash-object.c][hash-object] | 1.56 ± 1.56 | 39288 | subtracted from Tree and Incremental tests |


_The Time column shows the total time taken to hash the expected output of the library in the test (the expected objects for Tree and Incremental tests, or a chunk of bytes roughly the size of encoded data for the Write tests.) The Code Size column shows the total code size of the benchmark harness, including object generation code (which is included in all tests.)_



### Write Test

| Library | Format | Time<br>(μs) ▲ | Code Size<br>(bytes) | Time<br>Overhead | Hash |
|----|----|---:|---:|---:|---:|
| [MPack][mpack] (0.8.1) [(C)][mpack-write] | MessagePack | 3.06 ± 4.46 | 64648 | 3.49 ± 4.94 | 1a9c6681 |
| [MPack][mpack] (0.8.1) \[tracking] [(C)][mpack-tracking-write] | MessagePack | 4.88 ± 6.23 | 74488 | 4.97 ± 7.03 | 1a9c6681 |
| [Zigpak][zigpak] (0.3.0) [(Zig)][zigpak-write] | MessagePack | 9.81 ± 11.11 | 3144 | 8.99 ± 12.72 | bcfb74f1 |



_The Time and Code Size columns show the net result after subtracting the hash-data time and size. The Time Overhead column shows the total time of the benchmark divided by the total time of hash-data. In all three columns, lower is better._



### Tree Test

| Library | Format | Time<br>(μs) ▲ | Code Size<br>(bytes) | Time<br>Overhead | Hash |
|----|----|---:|---:|---:|---:|
| [MPack][mpack] (0.8.1) [(C)][mpack-node] | MessagePack | 15.96 ± 17.59 | 64200 | 11.22 ± 15.87 | 0075ff81 |
| [MPack][mpack] (0.8.1) \[UTF-8] [(C)][mpack-utf8-node] | MessagePack | 17.67 ± 19.29 | 64296 | 12.32 ± 17.42 | 0075ff81 |



_The Time and Code Size columns show the net result after subtracting the hash-object time and size. The Time Overhead column shows the total time of the benchmark divided by the total time of hash-object. In all three columns, lower is better._



### Incremental Parse Test

| Library | Format | Time<br>(μs) ▲ | Code Size<br>(bytes) | Time<br>Overhead | Hash |
|----|----|---:|---:|---:|---:|
| [MPack][mpack] (0.8.1) [(C)][mpack-read] | MessagePack | 3.73 ± 5.52 | 63880 | 3.39 ± 4.80 | 0075ff81 |
| [MPack][mpack] (0.8.1) \[tracking] [(C)][mpack-tracking-read] | MessagePack | 5.37 ± 7.10 | 73800 | 4.44 ± 6.28 | 0075ff81 |
| [Zigpak][zigpak] (0.3.0) [(Zig)][zigpak-read] | MessagePack | 5.52 ± 7.25 | 5552 | 4.54 ± 6.42 | 07d6c601 |
| [MPack][mpack] (0.8.1) \[UTF-8] [(C)][mpack-utf8-read] | MessagePack | 5.73 ± 7.46 | 63880 | 4.67 ± 6.61 | 0075ff81 |



_The Time and Code Size columns show the net result after subtracting the hash-object time and size. The Time Overhead column shows the total time of the benchmark divided by the total time of hash-object. In all three columns, lower is better._


## Large Data


### Hash Comparisons

| Benchmark | Time<br>(μs) | Code Size<br>(bytes) | Comparison |
|----|---:|---:|----|
| [hash-data.c][hash-data] | 78.50 ± 78.50 | 38312 | subtracted from Write tests |
| [hash-object.c][hash-object] | 349.18 ± 349.18 | 39288 | subtracted from Tree and Incremental tests |


_The Time column shows the total time taken to hash the expected output of the library in the test (the expected objects for Tree and Incremental tests, or a chunk of bytes roughly the size of encoded data for the Write tests.) The Code Size column shows the total code size of the benchmark harness, including object generation code (which is included in all tests.)_



### Write Test

| Library | Format | Time<br>(μs) ▲ | Code Size<br>(bytes) | Time<br>Overhead | Hash |
|----|----|---:|---:|---:|---:|
| [MPack][mpack] (0.8.1) [(C)][mpack-write] | MessagePack | 739.84 ± 822.10 | 64648 | 10.43 ± 14.74 | b4ac134d |
| [MPack][mpack] (0.8.1) \[tracking] [(C)][mpack-tracking-write] | MessagePack | 830.35 ± 912.23 | 74488 | 11.58 ± 16.37 | b4ac134d |
| [Zigpak][zigpak] (0.3.0) [(Zig)][zigpak-write] | MessagePack | 1594.47 ± 1674.80 | 3144 | 21.31 ± 30.14 | db04c300 |



_The Time and Code Size columns show the net result after subtracting the hash-data time and size. The Time Overhead column shows the total time of the benchmark divided by the total time of hash-data. In all three columns, lower is better._



### Tree Test

| Library | Format | Time<br>(μs) ▲ | Code Size<br>(bytes) | Time<br>Overhead | Hash |
|----|----|---:|---:|---:|---:|
| [MPack][mpack] (0.8.1) [(C)][mpack-node] | MessagePack | 818.27 ± 1218.55 | 64200 | 3.34 ± 4.73 | 91b5d7ef |
| [MPack][mpack] (0.8.1) \[UTF-8] [(C)][mpack-utf8-node] | MessagePack | 1013.31 ± 1406.52 | 64296 | 3.90 ± 5.52 | 91b5d7ef |



_The Time and Code Size columns show the net result after subtracting the hash-object time and size. The Time Overhead column shows the total time of the benchmark divided by the total time of hash-object. In all three columns, lower is better._



### Incremental Parse Test

| Library | Format | Time<br>(μs) ▲ | Code Size<br>(bytes) | Time<br>Overhead | Hash |
|----|----|---:|---:|---:|---:|
| [MPack][mpack] (0.8.1) [(C)][mpack-read] | MessagePack | 315.12 ± 750.48 | 63880 | 1.90 ± 2.69 | 91b5d7ef |
| [Zigpak][zigpak] (0.3.0) [(Zig)][zigpak-read] | MessagePack | 335.69 ± 768.75 | 5552 | 1.96 ± 2.77 | b29a81b7 |
| [MPack][mpack] (0.8.1) \[tracking] [(C)][mpack-tracking-read] | MessagePack | 408.14 ± 833.94 | 73800 | 2.17 ± 3.07 | 91b5d7ef |
| [MPack][mpack] (0.8.1) \[UTF-8] [(C)][mpack-utf8-read] | MessagePack | 537.11 ± 952.59 | 63880 | 2.54 ± 3.59 | 91b5d7ef |



_The Time and Code Size columns show the net result after subtracting the hash-object time and size. The Time Overhead column shows the total time of the benchmark divided by the total time of hash-object. In all three columns, lower is better._


