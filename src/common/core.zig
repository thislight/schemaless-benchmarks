const std = @import("std");

pub const MetaInfo = struct {
    is_benchmark: bool,
    version: [:0]const u8,
    format: [:0]const u8,
    filename: [:0]const u8,
};

extern fn load_data_file(format: [*:0]const c_char, object_size: usize, size_out: *usize) callconv(.C) ?[*:0]c_char;

pub const DataFile = struct {
    allocator: std.mem.Allocator,
    data: []u8,

    pub const FORMAT_MESSAGEPACK = "mp";

    pub fn load(format: [:0]const u8, objectSize: usize) error{FileNotFound}!DataFile {
        var fileSize: usize = 0;
        const data = load_data_file(
            @ptrCast(format),
            objectSize,
            &fileSize,
        ) orelse return error.FileNotFound;
        const slice = data[0..fileSize];

        return .{
            .allocator = std.heap.c_allocator,
            .data = @ptrCast(slice),
        };
    }

    pub fn deinit(self: *DataFile) void {
        self.allocator.free(self.data);
        self.* = undefined;
    }
};

const inSituCopying = false;

pub inline fn copyIfInSitu(data: []const u8) ![]const u8 {
    if (!inSituCopying) {
        return data;
    }

    return try std.heap.c_allocator.dupe(u8, data);
}

pub fn freeIfInSitu(data: []const u8) void {
    if (inSituCopying) {
        std.heap.c_allocator.free(data);
    }
}

pub fn hash(comptime T: type, ohash: u32, value: T) u32 {
    return switch (T) {
        @TypeOf(null), void => hash([]const u8, hash(u32, ohash, 0), "nil"),
        u16 => hash(u32, ohash, value),
        u32 => ohash * 31 ^ value,
        u64 => hash(u32, hash(u32, ohash, @truncate(value >> 32)), @truncate(value)),
        i8, i16, i32 => hash(u32, ohash, @bitCast(value)),
        i64 => hash(u64, ohash, @bitCast(value)),
        bool => hash(u32, ohash, if (value) 1 else 0),
        f32, f64 => hash(u32, ohash, 43013), // skipped, see hash.h
        []const u8 => strHash: {
            var h = hash(u32, ohash, @truncate(value.len));
            var win = std.mem.window(u8, value, 4, 4);
            while (win.next()) |w| {
                var buf = [_]u8{ 0, 0, 0, 0 };
                @memcpy(&buf, w);
                h = hash(u32, h, std.mem.readInt(u32, &buf, .little));
            }
            break :strHash h;
        },
        else => unreachable,
    };
}

extern fn benchmark_object_create(objectSize: usize) *Object;
extern fn object_destroy(object: *Object) void;

pub const Object = extern struct {
    type: Type,
    len: u32,
    value: extern union {
        b: bool,
        d: f64,
        i: i64,
        u: u64,
        children: [*]Object,
        str: [*:0]c_char,
    },

    pub const Type = enum(c_int) {
        nil = 1,
        bool,
        double,
        int,
        uint,
        str,
        array,
        map,
    };

    pub fn create(size: usize) *@This() {
        return benchmark_object_create(size);
    }

    pub fn deinit(self: *@This()) void {
        object_destroy(self);
    }
};
