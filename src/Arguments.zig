const std = @import("std");
const ansi = @import("ansi.zig");

pub const ArgumentErrors = error{UnknownArgument};

pub const ArgumentType = union(enum) {
    Text: ?[]u8,
    Int: ?i64,
    Float: ?f64,
    fn toString(self: ArgumentType) []const u8 {
        return switch (self) {
            .Text => "String",
            .Int => "Integer",
            .Float => "Float",
        };
    }
};

pub const Argument = struct {
    name: []const u8,
    description: []const u8,
    value: ArgumentType,
    optional: bool,

    pub fn init(name: []const u8, description: []const u8, value: ArgumentType, optional: bool) Argument {
        return Argument{ .name = name, .description = description, .value = value, .optional = optional };
    }

    pub fn helpCommand(self: Argument) !void {
        // ------------------------- STDOUT -------------------------
        const stdout_file = std.io.getStdOut().writer();
        var bw = std.io.bufferedWriter(stdout_file);
        const stdout = bw.writer();

        // ------------------------- Process -------------------------
        try stdout.print("└─ {s}{s}{s} <{s}{s}{s}> {s} : {s}{s}\n", .{ ansi.TextColors.Black, self.name, ansi.AnsiUtils.ResetColors, ansi.TextColors.Black, self.value.toString(), ansi.AnsiUtils.ResetColors, if (self.optional) "[Optional]" else "", self.description, ansi.AnsiUtils.ResetColors });

        try bw.flush();
    }
};
