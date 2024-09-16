const std = @import("std");
const cli = @import("cli.zig");
const Commands = @import("Commands.zig");

pub fn main() !void {
    const c1: Commands.Command = Commands.Command.init("command");
    const c2: Commands.Command = Commands.Command.init("command2");

    const appCli: cli.ZigCli = cli.ZigCli.init("ZigCli", &[_]Commands.Command{ c1, c2 });

    try appCli.run();
}
