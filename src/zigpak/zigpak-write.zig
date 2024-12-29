const std = @import("std");
const core = @import("benchmark");
const zigpak = @import("zigpak");

pub fn getMetaInfo() core.MetaInfo {
    return .{
        .is_benchmark = true,
        .version = "0.3.0",
        .format = "MessagePack",
        .filename = @src().file,
    };
}

object: *core.Object,

pub fn init(objectSize: usize) !@This() {
    return .{
        .object = core.Object.create(objectSize),
    };
}

pub fn deinit(self: @This()) void {
    self.object.deinit();
}

const io = zigpak.io;

fn writeObject(writer: anytype, object: *core.Object) void {
    switch (object.type) {
        .nil => _ = io.writeNil(writer) catch unreachable,
        .bool => _ = io.writeBool(writer, object.value.b) catch unreachable,
        .int => _ = io.writeInt(writer, object.value.i) catch unreachable,
        .uint => _ = io.writeInt(writer, object.value.u) catch unreachable,
        .double => _ = io.writeFloat(writer, object.value.d) catch unreachable,
        .str => _ = io.writeString(writer, @ptrCast(std.mem.span(object.value.str))) catch unreachable,
        .array => {
            _ = io.writeArrayPrefix(writer, object.len) catch unreachable;
            for (object.value.children[0..object.len]) |*o| {
                writeObject(writer, o);
            }
        },
        .map => {
            _ = io.writeMapPrefix(writer, object.len) catch unreachable;
            for (object.value.children[0 .. object.len * 2]) |*o| {
                writeObject(writer, o);
            }
        },
    }
}

pub fn run(self: *@This(), hasho: *u32) !void {
    var growableBuffer = std.ArrayList(u8).init(std.heap.c_allocator);
    defer growableBuffer.deinit();

    writeObject(growableBuffer.writer(), self.object);

    hasho.* = core.hash([]const u8, hasho.*, growableBuffer.items);
}
