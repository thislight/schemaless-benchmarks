const std = @import("std");
const Benchmark = @import("content");
const core = @import("benchmark");

fn metaInfo() core.MetaInfo {
    return @as(core.MetaInfo, Benchmark.getMetaInfo());
}

export fn is_benchmark() callconv(.C) bool {
    return metaInfo().is_benchmark;
}

export fn test_version() callconv(.C) [*:0]const c_char {
    return @ptrCast(metaInfo().version);
}

export fn test_language() callconv(.C) [*:0]const c_char {
    return @ptrCast("Zig");
}

export fn test_format() callconv(.C) [*:0]const c_char {
    return @ptrCast(metaInfo().format);
}

export fn test_filename() callconv(.C) [*:0]const c_char {
    return @ptrCast(metaInfo().filename);
}

var benchmark: Benchmark = undefined;

export fn setup_test(objectSize: usize) callconv(.C) bool {
    benchmark = Benchmark.init(objectSize) catch |err| {
        std.debug.print("error: {}\n", .{err});
        if (@errorReturnTrace()) |trace| {
            std.debug.print("{}\n", .{trace});
        }
        return false;
    };
    return true;
}

export fn teardown_test() callconv(.C) void {
    if (@hasDecl(Benchmark, "deinit")) {
        benchmark.deinit();
    }
}

export fn run_test(hashOut: ?*u32) callconv(.C) bool {
    benchmark.run(hashOut.?) catch |err| {
        std.debug.print("error: {}\n", .{err});
        if (@errorReturnTrace()) |trace| {
            std.debug.print("{}\n", .{trace});
        }
        return false;
    };
    return true;
}

pub extern fn main(argc: c_int, argv: [*][*:0]c_char) callconv(.C) c_int;
