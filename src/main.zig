const std = @import("std");
const cli = @import("cli.zig");
const Commands = @import("Commands.zig");
const Arguments = @import("Arguments.zig");
const Options = @import("Options.zig");

pub fn main() !void {
    const arguments1: []const Arguments.Argument = &[_]Arguments.Argument{
        try Arguments.Argument.init("argument1", "This is a random description for argument 1", Arguments.ArgumentType{ .Text = null }, false),
        try Arguments.Argument.init("argument2", "This is a fixed description for argument 2", Arguments.ArgumentType{ .Int = null }, true),
    };
    const arguments2: []const Arguments.Argument = &[_]Arguments.Argument{
        try Arguments.Argument.init("argumentA", "This is a random description for argument A", Arguments.ArgumentType{ .Float = null }, true),
    };
    const options1: []const Options.Option = &[_]Options.Option{
        try Options.Option.init("option1", "This is a random description for option 1"),
    };
    const options2: []const Options.Option = &[_]Options.Option{
        try Options.Option.init("optionA", "This is a random description for argument A"),
        try Options.Option.init("optionB", "This is a fixed description for argument B"),
    };
    const c1: Commands.Command = Commands.Command.init("command", "This is a random description for command 1", arguments1, options1);
    const c2: Commands.Command = Commands.Command.init("command2", "This is a fixed description for command 2", arguments2, options2);

    const appCli: cli.ZigCli = cli.ZigCli.init("ZigCli", &[_]Commands.Command{ c1, c2 });

    try appCli.run();
}
