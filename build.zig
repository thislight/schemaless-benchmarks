const std = @import("std");
const EnsurePath = @import("./buildkit/EnsurePath.zig");
const RunQueue = @import("./buildkit/RunQueue.zig");

const TestOptimizeTarget = enum {
    Speed,
    Size,
};

fn setDefaultFlags(b: *std.Build.Step.Compile, opt: TestOptimizeTarget) void {
    switch (opt) {
        .Size => {
            b.root_module.addCMacro("BENCHMARK_SIZE_OPTIMIZED", "1");
        },
        .Speed => {},
    }
    b.addIncludePath(b.step.owner.path("src/common/"));
    b.root_module.pic = true;
    b.root_module.addCMacro("NDEBUG", "");
    b.root_module.addCMacro("PIC", "1");
}

const DCFLAGS = &.{ "-Wall", "-fno-fat-lto-objects", "-std=c11" };

fn createObject(b: *std.Build, opt: TestOptimizeTarget, options: std.Build.ObjectOptions) *std.Build.Step.Compile {
    const obj = b.addObject(options);
    setDefaultFlags(obj, opt);
    obj.root_module.pic = true;
    return obj;
}

fn createExe(b: *std.Build, opt: TestOptimizeTarget, options: std.Build.ExecutableOptions) *std.Build.Step.Compile {
    const obj = b.addExecutable(options);
    setDefaultFlags(obj, opt);
    obj.want_lto = true;
    obj.root_module.strip = obj.root_module.strip orelse true;
    obj.root_module.pic = true;
    b.installArtifact(obj);
    return obj;
}

fn createRunBenchmark(runQ: *RunQueue, exe: *std.Build.Step.Compile, args: []const []const u8) *std.Build.Step.Run {
    const b = exe.step.owner;
    const run = b.addRunArtifact(exe);
    run.addArgs(args);
    runQ.append(&run.step);
    return run;
}

const MPackTestOptions = struct {
    rawOptimize: TestOptimizeTarget,
    optimize: std.builtin.OptimizeMode,
    target: std.Build.ResolvedTarget,
    objects: []const *std.Build.Step.Compile,
    sourceName: ?[]const u8 = null,
    checkUtf8: bool = false,
    tracking: bool = false,
};

fn createMPackTest(
    b: *std.Build,
    name: []const u8,
    opts: MPackTestOptions,
) *std.Build.Step.Compile {
    const mpack = b.dependency("mpack", .{});
    // mpack-write
    const benchMain = createObject(b, opts.rawOptimize, .{
        .name = name,
        .optimize = opts.optimize,
        .target = opts.target,
        .link_libc = true,
    });
    const filename = std.fmt.allocPrint(
        b.allocator,
        "src/mpack/{s}.c",
        .{opts.sourceName orelse name},
    ) catch @panic("OOM");
    benchMain.addCSourceFile(.{
        .file = b.path(filename),
        .flags = DCFLAGS,
    });
    benchMain.addIncludePath(mpack.path("src"));
    benchMain.addIncludePath(b.named_writefiles.get("generatedIncludes").?.getDirectory());

    const exe = createExe(b, opts.rawOptimize, .{
        .name = name,
        .optimize = opts.optimize,
        .target = opts.target,
        .link_libc = true,
    });
    exe.addObject(benchMain);
    for (opts.objects) |o| exe.addObject(o);

    if (opts.checkUtf8) {
        benchMain.root_module.addCMacro("CHECK_UTF8", "1");
        exe.root_module.addCMacro("CHECK_UTF8", "1");
    }

    if (opts.tracking) {
        inline for (&.{ benchMain, exe }) |c| {
            c.root_module.addCMacro("MPACK_READ_TRACKING", "1");
            c.root_module.addCMacro("MPACK_WRITE_TRACKING", "1");
        }
    }

    return exe;
}

const ZigpakTestOptions = struct {
    optimize: std.builtin.OptimizeMode,
    target: std.Build.ResolvedTarget,
    zigpak: *std.Build.Module,
    source_file: std.Build.LazyPath,
};

fn createZigpakTest(b: *std.Build, name: []const u8, opts: ZigpakTestOptions) *std.Build.Step.Compile {
    const exe = b.addExecutable(.{
        .name = name,
        .optimize = opts.optimize,
        .target = opts.target,
        .link_libc = true,
        .root_source_file = b.path("./src/common/glue.zig"),
        .strip = true,
        .pic = true,
    });
    exe.want_lto = true;
    const content = b.createModule(.{
        .root_source_file = opts.source_file,
        .optimize = opts.optimize,
        .target = opts.target,
    });
    content.addImport("zigpak", opts.zigpak);

    const frameworkM = b.modules.get("benchmark") orelse @panic("benchmark module not found");
    content.addImport("benchmark", frameworkM);

    exe.root_module.addImport("content", content);
    exe.root_module.addImport("benchmark", frameworkM);

    b.installArtifact(exe);

    return exe;
}

fn defaultTestObjectSizes(opt: TestOptimizeTarget) std.BoundedArray([]const u8, 5) {
    var testObjectSizes: std.BoundedArray([]const u8, 5) = .{};

    switch (opt) {
        .Size => testObjectSizes.appendSliceAssumeCapacity(&.{"2"}),
        .Speed => testObjectSizes.appendSliceAssumeCapacity(&.{ "2", "4" }),
    }

    return testObjectSizes;
}

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    const rawOptimize = b.option(TestOptimizeTarget, "optimize", "Test seepd or size (default: Speed)") orelse .Speed;

    const optimize: std.builtin.OptimizeMode = switch (rawOptimize) {
        .Size => .ReleaseSmall,
        .Speed => .ReleaseFast,
    };

    const testObjectSizes = defaultTestObjectSizes(rawOptimize);

    const benchmark = b.step("benchmark", "Run benchmark");
    const stepCheck = b.step("check", "Build but don't install");

    const stepZigpak = b.step("zigpak", "Run zigpak benchmark");

    const runQ = RunQueue.create(b);
    defer runQ.finalize();
    benchmark.dependOn(&runQ.step);

    const buildDir = makeBuildDir: {
        const buildDir = EnsurePath.create(b, .{ .sub_path = "build" });
        break :makeBuildDir buildDir;
    };

    const genIncludes = makeGeneratedIncludes: { // mpack-config.h
        const mpack = b.dependency("mpack", .{});

        const conf = b.addNamedWriteFiles("generatedIncludes");
        _ = conf.addCopyFile(mpack.path("src/mpack-config.h.sample"), "mpack-config.h");
        break :makeGeneratedIncludes conf.getDirectory();
    };

    const framework = makeFramework: { // common
        const mpack = b.dependency("mpack", .{});

        const common = createObject(b, rawOptimize, .{
            .name = "common",
            .optimize = optimize,
            .target = target,
            .link_libc = true,
        });

        common.addIncludePath(mpack.path("."));
        common.addIncludePath(genIncludes);

        common.addCSourceFiles(.{
            .files = &.{
                "generator.c",
                "benchmark.c",
            },
            .flags = DCFLAGS,
            .root = b.path("src/common/"),
        });

        break :makeFramework common;
    };

    {
        const hashObjectExe = createExe(b, rawOptimize, .{
            .name = "hash-object",
            .optimize = optimize,
            .target = target,
            .link_libc = true,
        });
        hashObjectExe.addCSourceFile(.{
            .file = b.path("src/hash/hash-object.c"),
            .flags = DCFLAGS,
        });
        hashObjectExe.addObject(framework);

        _ = createRunBenchmark(runQ, hashObjectExe, testObjectSizes.constSlice());
    }

    {
        const hashDataExe = createExe(b, rawOptimize, .{
            .name = "hash-data",
            .optimize = optimize,
            .target = target,
            .link_libc = true,
        });
        hashDataExe.addCSourceFile(.{
            .file = b.path("src/hash/hash-data.c"),
            .flags = DCFLAGS,
        });
        hashDataExe.addObject(framework);

        _ = createRunBenchmark(runQ, hashDataExe, testObjectSizes.constSlice());
    }

    const mpackO = makeMPack: {
        const mpack = b.dependency("mpack", .{});

        const mpacko = createObject(b, rawOptimize, .{
            .name = "mpack",
            .optimize = optimize,
            .target = target,
            .link_libc = true,
        });
        mpacko.addIncludePath(mpack.path("src"));
        mpacko.addIncludePath(genIncludes);
        mpacko.addCSourceFiles(.{
            .files = &.{
                "mpack/mpack.c",
            },
            .flags = DCFLAGS,
            .root = mpack.path("./src/"),
        });
        break :makeMPack mpacko;
    };

    const setupMsgpackData = makeMsgpackData: {
        const exe = createMPackTest(
            b,
            "mpack-file",
            .{
                .rawOptimize = rawOptimize,
                .optimize = optimize,
                .target = target,
                .objects = &.{ mpackO, framework },
            },
        );

        const run = b.addRunArtifact(exe);
        run.addArgs(&.{ "1", "2", "3", "4", "5" });
        run.step.dependOn(&buildDir.step);
        break :makeMsgpackData run;
    };

    inline for (&.{ "write", "read", "node" }) |variant| {
        const exe = createMPackTest(
            b,
            "mpack-" ++ variant,
            .{
                .rawOptimize = rawOptimize,
                .optimize = optimize,
                .target = target,
                .objects = &.{ mpackO, framework },
            },
        );

        const run = createRunBenchmark(runQ, exe, testObjectSizes.constSlice());
        run.step.dependOn(&setupMsgpackData.step);
    }

    const mpackTrackingO = makeTrackingMpack: {
        const mpack = b.dependency("mpack", .{});

        const obj = createObject(b, rawOptimize, .{
            .name = "mpack-tracking",
            .optimize = optimize,
            .target = target,
            .link_libc = true,
        });
        obj.root_module.addCMacro("MPACK_READ_TRACKING", "1");
        obj.root_module.addCMacro("MPACK_WRITE_TRACKING", "1");
        obj.addIncludePath(mpack.path("src"));
        obj.addIncludePath(genIncludes);
        obj.addCSourceFiles(.{
            .files = &.{
                "mpack/mpack.c",
            },
            .flags = DCFLAGS,
            .root = mpack.path("./src/"),
        });

        break :makeTrackingMpack obj;
    };

    inline for (&.{ "write", "read" }) |variant| {
        const exe = createMPackTest(
            b,
            "mpack-tracking-" ++ variant,
            .{
                .rawOptimize = rawOptimize,
                .optimize = optimize,
                .target = target,
                .objects = &.{ mpackTrackingO, framework },
                .sourceName = "mpack-" ++ variant,
                .tracking = true,
            },
        );

        const run = createRunBenchmark(runQ, exe, testObjectSizes.constSlice());
        run.step.dependOn(&setupMsgpackData.step);
    }

    inline for (&.{ "read", "node" }) |variant| {
        const exe = createMPackTest(
            b,
            "mpack-utf8-" ++ variant,
            .{
                .rawOptimize = rawOptimize,
                .optimize = optimize,
                .target = target,
                .objects = &.{ mpackO, framework },
                .checkUtf8 = true,
                .sourceName = "mpack-" ++ variant,
            },
        );

        const run = createRunBenchmark(runQ, exe, testObjectSizes.constSlice());
        run.step.dependOn(&setupMsgpackData.step);
    }
    const zigpakD = b.dependency("zigpak", .{
        .target = target,
        .optimize = optimize,
    });
    const zigpakM = zigpakD.module("zigpak");

    const frameworkM = b.addModule("benchmark", .{
        .root_source_file = b.path("./src/common/core.zig"),
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });
    frameworkM.addObject(framework);

    {
        const exe = createZigpakTest(b, "zigpak-read", .{
            .optimize = optimize,
            .target = target,
            .zigpak = zigpakM,
            .source_file = b.path("./src/zigpak/zigpak-read.zig"),
        });

        _ = createRunBenchmark(runQ, exe, testObjectSizes.constSlice());

        const run = b.addRunArtifact(exe);
        run.addArgs(testObjectSizes.constSlice());
        stepZigpak.dependOn(&run.step);

        stepCheck.dependOn(&exe.step);
    }

    {
        const exe = createZigpakTest(b, "zigpak-write", .{
            .optimize = optimize,
            .target = target,
            .zigpak = zigpakM,
            .source_file = b.path("./src/zigpak/zigpak-write.zig"),
        });

        _ = createRunBenchmark(runQ, exe, testObjectSizes.constSlice());

        const run = b.addRunArtifact(exe);
        run.addArgs(testObjectSizes.constSlice());
        stepZigpak.dependOn(&run.step);

        stepCheck.dependOn(&exe.step);
    }
}
