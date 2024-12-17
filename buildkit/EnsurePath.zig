const std = @import("std");

const EnsurePath = @This();

step: std.Build.Step,
sub_path: []const u8,
root: ?std.Build.LazyPath,

generated_file: std.Build.GeneratedFile,

const InitOptions = struct {
    sub_path: []const u8,
    root: ?std.Build.LazyPath = null,
};

pub fn create(owner: *std.Build, options: InitOptions) *EnsurePath {
    const step = std.Build.Step.init(.{
        .owner = owner,
        .id = .custom,
        .name = std.fmt.allocPrint(
            owner.allocator,
            "mkdir -p {s}",
            .{options.sub_path},
        ) catch @panic("OOM"),
        .makeFn = make,
    });

    const ptr = owner.allocator.create(EnsurePath) catch @panic("OOM");
    ptr.* = .{
        .step = step,
        .sub_path = options.sub_path,
        .root = options.root,
        .generated_file = std.Build.GeneratedFile{
            .step = &ptr.step,
        },
    };

    return ptr;
}

pub fn make(step: *std.Build.Step, prog_node: std.Progress.Node) !void {
    const self: *EnsurePath = @fieldParentPtr("step", step);
    prog_node.setEstimatedTotalItems(1);

    const rootPath = if (self.root) |root|
        root.getPath2(step.owner, step)
    else
        step.owner.build_root.path.?;

    var dir = try std.fs.openDirAbsolute(rootPath, .{});
    defer dir.close();

    try dir.makePath(self.sub_path);

    self.generated_file.path = step.owner.pathJoin(&.{ rootPath, self.sub_path });
    prog_node.completeOne();
}

pub fn path(self: *EnsurePath) std.Build.LazyPath {
    return .{ .generated = .{
        .file = &self.generated_file,
    } };
}
