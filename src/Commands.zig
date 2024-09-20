const std = @import("std");
const ansi = @import("ansi.zig");
const Arguments = @import("Arguments.zig");
const Options = @import("Options.zig");

pub const CommandErrors = error{ UnknownCommand, NoCommand, UnknowParameter };

pub const Command = struct {
    name: []const u8,
    description: []const u8,
    arguments: []const Arguments.Argument,
    options: []const Options.Option,

    pub fn init(name: []const u8, description: []const u8, arguments: []const Arguments.Argument, options: []const Options.Option) Command {
        return Command{ .name = name, .description = description, .arguments = arguments, .options = options };
    }

    pub fn run(self: Command, args: [][]u8) !void {
        // ------------------------- STDOUT -------------------------
        const stdout_file = std.io.getStdOut().writer();
        var bw = std.io.bufferedWriter(stdout_file);
        const stdout = bw.writer();

        // ------------------------- Parsing Arguments -------------------------
        var i: usize = 1;
        while (i < args.len) : (i += 1) {
            const arg = args[i];

            // if --help command, exit after
            if (std.mem.eql(u8, arg, "--help")) {
                try self.helpCommand(true);
                break;
            } else {
                if (arg.len >= 2) {
                    if (arg[0] == 45) {
                        if (arg[1] == 45) {
                            if (arg.len >= 3) {
                                // => Argument
                                var knowArgument: ?Arguments.Argument = null;
                                for (self.arguments) |argument| {
                                    if (std.mem.eql(u8, argument.name, arg[2..])) {
                                        knowArgument = argument;
                                        break;
                                    }
                                }
                                if (knowArgument) |value| {
                                    // => need to replicate argument in the result of the function with a parameter saying it was activated
                                    try stdout.print("Found Argument '{s}'\n", .{value.name});
                                    try bw.flush();
                                    // => need to parse next args to get the value
                                } else {
                                    try stdout.print("{s}error:{s}\n└─ {s}ArgumentErrors.UnknownArgument : {s}{s}\n\n", .{ ansi.TextColors.Red, ansi.AnsiUtils.ResetColors, ansi.TextColors.BrightRed, ansi.AnsiUtils.ResetColors, arg });
                                    try bw.flush();
                                    try self.helpCommand(false);
                                    return Arguments.ArgumentErrors.UnknownArgument;
                                }
                            } else {
                                try stdout.print("{s}error:{s}\n└─ {s}CommandErrors.UnknowParameter : {s}{s}\n\n", .{ ansi.TextColors.Red, ansi.AnsiUtils.ResetColors, ansi.TextColors.BrightRed, ansi.AnsiUtils.ResetColors, arg });
                                try bw.flush();
                                try self.helpCommand(false);
                                return CommandErrors.UnknowParameter;
                            }
                        } else {
                            // => Option
                            var knowOption: ?Options.Option = null;
                            for (self.options) |option| {
                                if (std.mem.eql(u8, option.name, arg[1..])) {
                                    knowOption = option;
                                    break;
                                }
                            }
                            if (knowOption) |value| {
                                // => need to replicate option in the result of the function with a parameter saying it was activated
                                try stdout.print("Found option '{s}'\n", .{value.name});
                                try bw.flush();
                            } else {
                                try stdout.print("{s}error:{s}\n└─ {s}OptionErrors.UnknownOption : {s}{s}\n\n", .{ ansi.TextColors.Red, ansi.AnsiUtils.ResetColors, ansi.TextColors.BrightRed, ansi.AnsiUtils.ResetColors, arg });
                                try bw.flush();
                                try self.helpCommand(false);
                                return Options.OptionErrors.UnknownOption;
                            }
                        }
                    } else {
                        try stdout.print("{s}error:{s}\n└─ {s}CommandErrors.UnknowParameter : {s}{s}\n\n", .{ ansi.TextColors.Red, ansi.AnsiUtils.ResetColors, ansi.TextColors.BrightRed, ansi.AnsiUtils.ResetColors, arg });
                        try bw.flush();
                        try self.helpCommand(false);
                        return CommandErrors.UnknowParameter;
                    }
                } else {
                    try stdout.print("{s}error:{s}\n└─ {s}CommandErrors.UnknowParameter : {s}{s}\n\n", .{ ansi.TextColors.Red, ansi.AnsiUtils.ResetColors, ansi.TextColors.BrightRed, ansi.AnsiUtils.ResetColors, arg });
                    try bw.flush();
                    try self.helpCommand(false);
                    return CommandErrors.UnknowParameter;
                }
            }
        }
    }

    pub fn helpCommand(self: Command, title: bool) !void {
        // ------------------------- STDOUT -------------------------
        const stdout_file = std.io.getStdOut().writer();
        var bw = std.io.bufferedWriter(stdout_file);
        const stdout = bw.writer();

        if (title) try stdout.print("{s}Welcome to the Command's Helper{s}\n========================\n", .{ ansi.TextColors.Blue, ansi.AnsiUtils.ResetColors });

        try stdout.print("─ {s}{s}{s} : {s}\n", .{ ansi.TextColors.Green, self.name, ansi.AnsiUtils.ResetColors, self.description });
        try bw.flush();

        for (self.arguments) |argument| {
            try argument.helpCommand();
        }
        for (self.options) |option| {
            try option.helpCommand();
        }
        try stdout.print("\n", .{});
        try bw.flush();
    }
};
