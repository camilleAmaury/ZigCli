const std = @import("std");
const cli = @import("cli.zig");
const Commands = @import("Commands.zig");
const Arguments = @import("Arguments.zig");

pub fn main() !void {
    const arguments1: []const Arguments.Argument = &[_]Arguments.Argument{
        Arguments.Argument.init("--argument1", "This is a random description for argument 1", Arguments.ArgumentType{ .Text = null }, false),
        Arguments.Argument.init("--argument2", "This is a fixed description for argument 2", Arguments.ArgumentType{ .Int = null }, true),
    };
    const arguments2: []const Arguments.Argument = &[_]Arguments.Argument{
        Arguments.Argument.init("--argumentA", "This is a random description for argument A", Arguments.ArgumentType{ .Float = null }, true),
    };
    const c1: Commands.Command = Commands.Command.init("command", arguments1);
    const c2: Commands.Command = Commands.Command.init("command2", arguments2);

    const appCli: cli.ZigCli = cli.ZigCli.init("ZigCli", &[_]Commands.Command{ c1, c2 });

    try appCli.run();
}
