const std = @import("std");
const ansi = @import("ansi.zig");
const Arguments = @import("Arguments.zig");

pub const CommandErrors = error{ UnknownCommand, NoCommand };

pub const Command = struct {
    name: []const u8,
    arguments: []const Arguments.Argument,
    // options: []const Options,

    pub fn init(name: []const u8, arguments: []const Arguments.Argument) Command {
        return Command{ .name = name, .arguments = arguments };
    }

    pub fn run(self: Command, args: [][]u8) !void {
        // ------------------------- STDOUT -------------------------
        // const stdout_file = std.io.getStdOut().writer();
        // var bw = std.io.bufferedWriter(stdout_file);
        // const stdout = bw.writer();

        // ------------------------- Parsing Arguments -------------------------
        var i: usize = 1;
        while (i < args.len) : (i += 1) {
            const arg = args[i];

            // if --help command, exit after
            if (std.mem.eql(u8, arg, "--help")) {
                try self.helpCommand();
            } else {}
        }
    }

    pub fn helpCommand(self: Command) !void {
        // ------------------------- STDOUT -------------------------
        const stdout_file = std.io.getStdOut().writer();
        var bw = std.io.bufferedWriter(stdout_file);
        const stdout = bw.writer();

        try stdout.print("{s}Welcome to the Command's Helper{s}\n========================\n", .{ ansi.TextColors.Blue, ansi.AnsiUtils.ResetColors });

        try stdout.print("─ {s}{s}{s}\n", .{ ansi.TextColors.Green, self.name, ansi.AnsiUtils.ResetColors });
        try bw.flush();

        for (self.arguments) |argument| {
            try argument.helpCommand();
        }
    }
};
