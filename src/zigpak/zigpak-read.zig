const std = @import("std");
const core = @import("benchmark");
const zigpak = @import("zigpak");
const hash = core.hash;

gpa: std.heap.GeneralPurposeAllocator(.{}) = .{},
file: core.DataFile,

pub fn getMetaInfo() core.MetaInfo {
    return .{
        .filename = @src().file,
        .format = "MessagePack",
        .is_benchmark = true,
        .version = "0.2.1",
    };
}

pub fn init(objectSize: usize) !@This() {
    const file = try core.DataFile.load(core.DataFile.FORMAT_MESSAGEPACK, objectSize);
    return .{
        .file = file,
    };
}

pub fn deinit(self: *@This()) void {
    self.file.deinit();
}

fn hashElement(unpack: *zigpak.Unpack, hasho: *u32, head: zigpak.Header) !void {
    hasho.* = switch (head.type.family()) {
        .nil => hash(void, hasho.*, {
            _ = unpack.raw(head); // Workaround a bug in unpack.nil
        }),
        .bool => hash(bool, hasho.*, try unpack.bool(head)),
        .int => hash(i64, hasho.*, try unpack.int(i64, head)),
        .uint => hash(u64, hasho.*, try unpack.int(u64, head)),
        .float => hash(f64, hasho.*, try unpack.float(f64, head)),
        .str, .bin => hash([]const u8, hasho.*, unpack.raw(head)),
        .array => hashArray: {
            var iter = try unpack.array(head);
            var h = hasho.*;
            while (try iter.peek()) |peeki| {
                const headi = iter.next(peeki);
                try hashElement(unpack, &h, headi);
            }
            break :hashArray h;
        },
        .map => hashMap: {
            var iter = try unpack.map(head);
            var h = hasho.*;
            while (try iter.peek()) |peekk| {
                const headk = iter.next(peekk);
                try hashElement(unpack, &h, headk);
                const peekv = try iter.peek() orelse unreachable;
                const headv = iter.next(peekv);
                try hashElement(unpack, &h, headv);
            }
            break :hashMap h;
        },
        else => unreachable,
    };
}

pub fn run(self: @This(), hasho: *u32) !void {
    const data = try core.copyIfInSitu(self.file.data);
    defer core.freeIfInSitu(data);

    var unpack = zigpak.Unpack.init(data);

    const peek = try unpack.peek();
    const head = unpack.next(peek);

    try hashElement(&unpack, hasho, head);
}
