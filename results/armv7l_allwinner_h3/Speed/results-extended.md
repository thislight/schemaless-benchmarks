
CPU model: ARMv7 Processor rev 5 (v7l)
Bogomips: 48.00
Sun, 29 Dec 2024 14:54:39 +0000
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
| [hash-data.c][hash-data] | 6.50 ± 6.50 | 39488 | subtracted from Write tests |
| [hash-object.c][hash-object] | 19.21 ± 19.21 | 40256 | subtracted from Tree and Incremental tests |


_The Time column shows the total time taken to hash the expected output of the library in the test (the expected objects for Tree and Incremental tests, or a chunk of bytes roughly the size of encoded data for the Write tests.) The Code Size column shows the total code size of the benchmark harness, including object generation code (which is included in all tests.)_



### Write Test

| Library | Format | Time<br>(μs) ▲ | Code Size<br>(bytes) | Time<br>Overhead | Hash |
|----|----|---:|---:|---:|---:|
| [MPack][mpack] (0.8.1) [(C)][mpack-write] | MessagePack | 35.43 ± 42.43 | 64352 | 6.45 ± 9.12 | 1a9c6681 |
| [MPack][mpack] (0.8.1) \[tracking] [(C)][mpack-tracking-write] | MessagePack | 60.99 ± 67.80 | 74128 | 10.38 ± 14.68 | 1a9c6681 |
| [Zigpak][zigpak] (0.3.0) [(Zig)][zigpak-write] | MessagePack | 104.20 ± 110.89 | 2848 | 17.03 ± 24.09 | bcfb74f1 |



_The Time and Code Size columns show the net result after subtracting the hash-data time and size. The Time Overhead column shows the total time of the benchmark divided by the total time of hash-data. In all three columns, lower is better._



### Tree Test

| Library | Format | Time<br>(μs) ▲ | Code Size<br>(bytes) | Time<br>Overhead | Hash |
|----|----|---:|---:|---:|---:|
| [MPack][mpack] (0.8.1) [(C)][mpack-node] | MessagePack | 80.73 ± 101.77 | 64168 | 5.20 ± 7.36 | 0075ff81 |
| [MPack][mpack] (0.8.1) \[UTF-8] [(C)][mpack-utf8-node] | MessagePack | 106.25 ± 126.92 | 64304 | 6.53 ± 9.24 | 0075ff81 |



_The Time and Code Size columns show the net result after subtracting the hash-object time and size. The Time Overhead column shows the total time of the benchmark divided by the total time of hash-object. In all three columns, lower is better._



### Incremental Parse Test

| Library | Format | Time<br>(μs) ▲ | Code Size<br>(bytes) | Time<br>Overhead | Hash |
|----|----|---:|---:|---:|---:|
| [MPack][mpack] (0.8.1) [(C)][mpack-read] | MessagePack | 39.88 ± 62.13 | 63856 | 3.08 ± 4.35 | 0075ff81 |
| [Zigpak][zigpak] (0.3.0) [(Zig)][zigpak-read] | MessagePack | 49.49 ± 71.33 | 5096 | 3.58 ± 5.06 | 07d6c601 |
| [MPack][mpack] (0.8.1) \[tracking] [(C)][mpack-tracking-read] | MessagePack | 65.67 ± 87.03 | 73672 | 4.42 ± 6.25 | 0075ff81 |
| [MPack][mpack] (0.8.1) \[UTF-8] [(C)][mpack-utf8-read] | MessagePack | 76.17 ± 97.29 | 63856 | 4.97 ± 7.02 | 0075ff81 |



_The Time and Code Size columns show the net result after subtracting the hash-object time and size. The Time Overhead column shows the total time of the benchmark divided by the total time of hash-object. In all three columns, lower is better._


## Large Data


### Hash Comparisons

| Benchmark | Time<br>(μs) | Code Size<br>(bytes) | Comparison |
|----|---:|---:|----|
| [hash-data.c][hash-data] | 576.37 ± 576.37 | 39488 | subtracted from Write tests |
| [hash-object.c][hash-object] | 2867.64 ± 2867.64 | 40256 | subtracted from Tree and Incremental tests |


_The Time column shows the total time taken to hash the expected output of the library in the test (the expected objects for Tree and Incremental tests, or a chunk of bytes roughly the size of encoded data for the Write tests.) The Code Size column shows the total code size of the benchmark harness, including object generation code (which is included in all tests.)_



### Write Test

| Library | Format | Time<br>(μs) ▲ | Code Size<br>(bytes) | Time<br>Overhead | Hash |
|----|----|---:|---:|---:|---:|
| [MPack][mpack] (0.8.1) [(C)][mpack-write] | MessagePack | 5185.76 ± 5790.89 | 64352 | 10.00 ± 14.14 | b4ac134d |
| [MPack][mpack] (0.8.1) \[tracking] [(C)][mpack-tracking-write] | MessagePack | 6939.75 ± 7538.19 | 74128 | 13.04 ± 18.44 | b4ac134d |
| [Zigpak][zigpak] (0.3.0) [(Zig)][zigpak-write] | MessagePack | 11589.66 ± 12179.68 | 2848 | 21.11 ± 29.85 | db04c300 |



_The Time and Code Size columns show the net result after subtracting the hash-data time and size. The Time Overhead column shows the total time of the benchmark divided by the total time of hash-data. In all three columns, lower is better._



### Tree Test

| Library | Format | Time<br>(μs) ▲ | Code Size<br>(bytes) | Time<br>Overhead | Hash |
|----|----|---:|---:|---:|---:|
| [MPack][mpack] (0.8.1) [(C)][mpack-node] | MessagePack | 4829.80 ± 8214.25 | 64168 | 2.68 ± 3.80 | 91b5d7ef |
| [MPack][mpack] (0.8.1) \[UTF-8] [(C)][mpack-utf8-node] | MessagePack | 7395.94 ± 10656.66 | 64304 | 3.58 ± 5.06 | 91b5d7ef |



_The Time and Code Size columns show the net result after subtracting the hash-object time and size. The Time Overhead column shows the total time of the benchmark divided by the total time of hash-object. In all three columns, lower is better._



### Incremental Parse Test

| Library | Format | Time<br>(μs) ▲ | Code Size<br>(bytes) | Time<br>Overhead | Hash |
|----|----|---:|---:|---:|---:|
| [MPack][mpack] (0.8.1) [(C)][mpack-read] | MessagePack | 2111.12 ± 5745.56 | 63856 | 1.74 ± 2.46 | 91b5d7ef |
| [Zigpak][zigpak] (0.3.0) [(Zig)][zigpak-read] | MessagePack | 2326.72 ± 5933.36 | 5096 | 1.81 ± 2.56 | b29a81b7 |
| [MPack][mpack] (0.8.1) \[tracking] [(C)][mpack-tracking-read] | MessagePack | 3972.89 ± 7417.29 | 73672 | 2.39 ± 3.37 | 91b5d7ef |
| [MPack][mpack] (0.8.1) \[UTF-8] [(C)][mpack-utf8-read] | MessagePack | 5552.52 ± 8895.08 | 63856 | 2.94 ± 4.15 | 91b5d7ef |



_The Time and Code Size columns show the net result after subtracting the hash-object time and size. The Time Overhead column shows the total time of the benchmark divided by the total time of hash-object. In all three columns, lower is better._


