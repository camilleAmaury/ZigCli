const std = @import("std");
const ansi = @import("ansi.zig");
const Commands = @import("Commands.zig");

pub const ZigCli = struct {
    name: []const u8,
    commands: []const Commands.Command,

    pub fn init(name: []const u8, commands: []const Commands.Command) ZigCli {
        return ZigCli{ .name = name, .commands = commands };
    }

    pub fn run(self: ZigCli) !void {
        // ------------------------- STDOUT -------------------------
        const stdout_file = std.io.getStdOut().writer();
        var bw = std.io.bufferedWriter(stdout_file);
        const stdout = bw.writer();

        // ------------------------- SYSTEM ARGS -------------------------
        const allocator = std.heap.page_allocator;
        const std_args = try std.process.argsAlloc(allocator);
        defer std.process.argsFree(allocator, std_args);

        // ------------------------- Parsing Arguments -------------------------

        if (std_args.len > 0) {
            const arg = std_args[1];
            var knownCommand: ?Commands.Command = null;

            // if --help command, exit after
            if (std.mem.eql(u8, arg, "--help")) {
                try self.helpCommand();
            } else {
                for (self.commands) |command| {
                    if (std.mem.eql(u8, arg, command.name)) {
                        knownCommand = command;
                        break;
                    }
                }
                if (knownCommand) |command| {
                    try command.run(std_args[1..]);
                } else {
                    try stdout.print("{s}error:{s}\n└─ {s}CommandErrors.UnknownCommand : {s}{s}\n", .{ ansi.TextColors.Red, ansi.AnsiUtils.ResetColors, ansi.TextColors.BrightRed, ansi.AnsiUtils.ResetColors, arg });
                    try bw.flush();
                    try self.listCommand(5);
                    return Commands.CommandErrors.UnknownCommand;
                }
            }
        } else {
            try stdout.print("{s}error:{s}\n└─ {s}CommandErrors.NoCommand : No Command was passed to the CLI{s}\n", .{
                ansi.TextColors.Red,
                ansi.AnsiUtils.ResetColors,
                ansi.TextColors.BrightRed,
                ansi.AnsiUtils.ResetColors,
            });
            try bw.flush();
            try self.listCommand(5);
            return Commands.CommandErrors.NoCommand;
        }
    }

    pub fn listCommand(self: ZigCli, max_items: usize) !void {
        // ------------------------- STDOUT -------------------------
        const stdout_file = std.io.getStdOut().writer();
        var bw = std.io.bufferedWriter(stdout_file);
        const stdout = bw.writer();

        try stdout.print("{s}Avalaible Commands:{s}\n", .{ ansi.TextColors.Blue, ansi.AnsiUtils.ResetColors });
        for (self.commands, 0..) |command, i| {
            try stdout.print("└─ {s}{s}{s} {s}--help{s}\n", .{ ansi.TextColors.Green, command.name, ansi.AnsiUtils.ResetColors, ansi.TextColors.Black, ansi.AnsiUtils.ResetColors });
            if (i == max_items - 1 and self.commands.len != max_items) {
                const other = if (self.commands.len == max_items + 1) "other" else "others";
                try stdout.print("└─ {s}... ({d} {s}){s}\n", .{ ansi.TextColors.Green, self.commands.len - max_items, other, ansi.AnsiUtils.ResetColors });
                break;
            }
        }

        try bw.flush();
    }

    pub fn helpCommand(self: ZigCli) !void {
        // ------------------------- STDOUT -------------------------
        const stdout_file = std.io.getStdOut().writer();
        var bw = std.io.bufferedWriter(stdout_file);
        const stdout = bw.writer();

        try stdout.print("{s}Welcome to {s}'s Helper{s}\n========================\n", .{ ansi.TextColors.Blue, self.name, ansi.AnsiUtils.ResetColors });
        try bw.flush();
        try self.listCommand(self.commands.len);
        try stdout.print("\n", .{});
        try bw.flush();
    }
};
