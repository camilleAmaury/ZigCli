const std = @import("std");
const ansi = @import("ansi.zig");
const Utils = @import("Utils.zig");

pub const OptionErrors = error{ UnknownOption, NamingError };

pub const Option = struct {
    name: []const u8,
    description: []const u8,

    pub fn init(comptime name: []const u8, description: []const u8) !Option {
        const indexes: []const bool = ansi.isAlphaNumerical(name);
        if (Utils.orSlice(indexes)) {
            const stdout_file = std.io.getStdOut().writer();
            var bw = std.io.bufferedWriter(stdout_file);
            const stdout = bw.writer();

            var underline: [name.len]u8 = undefined;
            for (0..indexes.len) |i| {
                underline[i] = if (indexes[i]) 126 else 32;
            }

            try stdout.print("{s}error:{s}\n└─ {s}OptionErrors.NamingError : {s}{s} => Only Alphanumerical Characters are allowed.\n", .{ ansi.TextColors.Red, ansi.AnsiUtils.ResetColors, ansi.TextColors.BrightRed, ansi.AnsiUtils.ResetColors, name });
            try stdout.print("                              {s}{s}{s}\n", .{ ansi.TextColors.Red, underline, ansi.AnsiUtils.ResetColors });
            try bw.flush();

            return OptionErrors.NamingError;
        }
        return Option{ .name = name, .description = description };
    }

    pub fn helpCommand(self: Option) !void {
        // ------------------------- STDOUT -------------------------
        const stdout_file = std.io.getStdOut().writer();
        var bw = std.io.bufferedWriter(stdout_file);
        const stdout = bw.writer();

        // ------------------------- Process -------------------------
        try stdout.print("└─ {s}-{s}{s} : {s}{s}\n", .{ ansi.TextColors.Black, self.name, ansi.AnsiUtils.ResetColors, self.description, ansi.AnsiUtils.ResetColors });

        try bw.flush();
    }
};
