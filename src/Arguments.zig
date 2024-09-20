const std = @import("std");
const ansi = @import("ansi.zig");
const Utils = @import("Utils.zig");

pub const ArgumentErrors = error{ UnknownArgument, NamingError };

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

    pub fn init(comptime name: []const u8, description: []const u8, value: ArgumentType, optional: bool) !Argument {
        const indexes: []const bool = ansi.isAlphaNumerical(name);
        if (Utils.orSlice(indexes)) {
            const stdout_file = std.io.getStdOut().writer();
            var bw = std.io.bufferedWriter(stdout_file);
            const stdout = bw.writer();

            var underline: [name.len]u8 = undefined;
            for (0..indexes.len) |i| {
                underline[i] = if (indexes[i]) 126 else 32;
            }

            try stdout.print("{s}error:{s}\n└─ {s}ArgumentErrors.NamingError : {s}{s} => Only Alphanumerical Characters are allowed.\n", .{ ansi.TextColors.Red, ansi.AnsiUtils.ResetColors, ansi.TextColors.BrightRed, ansi.AnsiUtils.ResetColors, name });
            try stdout.print("                                {s}{s}{s}\n", .{ ansi.TextColors.Red, underline, ansi.AnsiUtils.ResetColors });
            try bw.flush();

            return ArgumentErrors.NamingError;
        }
        return Argument{ .name = name, .description = description, .value = value, .optional = optional };
    }

    pub fn helpCommand(self: Argument) !void {
        // ------------------------- STDOUT -------------------------
        const stdout_file = std.io.getStdOut().writer();
        var bw = std.io.bufferedWriter(stdout_file);
        const stdout = bw.writer();

        // ------------------------- Process -------------------------
        try stdout.print("└─ {s}--{s}{s} <{s}{s}{s}> {s} : {s}{s}\n", .{ ansi.TextColors.Black, self.name, ansi.AnsiUtils.ResetColors, ansi.TextColors.Black, self.value.toString(), ansi.AnsiUtils.ResetColors, if (self.optional) "[Optional]" else "", self.description, ansi.AnsiUtils.ResetColors });

        try bw.flush();
    }
};
