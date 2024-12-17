//! Run independent steps in order.
//!
//! Use `create` to create a step, `append` to add steps in order.
//! After all steps are added, use `finalize` to complete the change.
//!
//! ```zig
//! const benchmark: *std.Build.Step;
//!
//! const runQ = RunQueue.create(b);
//! defer runQ.finalize();
//! benchmark.dependOn(&runQ.step);
//!
//! runQ.append(&run0.step);
//! runQ.append(&run1.step);
//! runQ.append(&run2.step);
//! ```
const std = @import("std");

step: std.Build.Step,
last: ?*std.Build.Step = null,

const RunQueue = @This();

pub fn create(b: *std.Build) *RunQueue {
    const ptr = b.allocator.create(RunQueue) catch @panic("OOM");
    ptr.* = .{ .step = std.Build.Step.init(.{
        .id = .custom,
        .owner = b,
        .name = "run queue",
    }) };
    return ptr;
}

pub fn append(self: *RunQueue, tail: *std.Build.Step) void {
    defer self.last = tail;

    if (self.last) |last| {
        tail.dependOn(last);
    }
}

pub fn finalize(self: *RunQueue) void {
    if (self.last) |last| {
        self.step.dependOn(last);
    }
}
