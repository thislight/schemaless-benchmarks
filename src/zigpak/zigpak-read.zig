const std = @import("std");
const core = @import("benchmark");
const zigpak = @import("zigpak");
const hash = core.hash;

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

fn hashElement(unpack: *zigpak.Unpack, hasho: *u32, head: zigpak.Header) void {
    hasho.* = switch (head.type.family()) {
        .nil => hash(void, hasho.*, {
            _ = unpack.raw(head); // Workaround a bug in unpack.nil
        }),
        .bool => hash(bool, hasho.*, unpack.bool(head) catch unreachable),
        .int => hash(i64, hasho.*, unpack.int(i64, head) catch unreachable),
        .uint => hash(u64, hasho.*, unpack.int(u64, head) catch unreachable),
        .float => hash(f64, hasho.*, unpack.float(f64, head) catch unreachable),
        .str, .bin => hash([]const u8, hasho.*, unpack.raw(head)),
        .array => hashArray: {
            var iter = unpack.array(head) catch unreachable;
            var h = hasho.*;
            while (iter.peek() catch unreachable) |peeki| {
                const headi = iter.next(peeki);
                hashElement(unpack, &h, headi);
            }
            break :hashArray h;
        },
        .map => hashMap: {
            var iter = unpack.map(head) catch unreachable;
            var h = hasho.*;
            while (iter.peek() catch unreachable) |peekk| {
                const headk = iter.next(peekk);
                hashElement(unpack, &h, headk);
                const peekv = iter.peek() catch unreachable orelse unreachable;
                const headv = iter.next(peekv);
                hashElement(unpack, &h, headv);
            }
            break :hashMap h;
        },
        else => unreachable,
    };
}

pub fn run(self: *@This(), hasho: *u32) !void {
    const data = try core.copyIfInSitu(self.file.data);
    defer core.freeIfInSitu(data);

    var unpack = zigpak.Unpack.init(data);

    const peek = unpack.peek() catch unreachable;
    const head = unpack.next(peek);

    hashElement(&unpack, hasho, head);
}
