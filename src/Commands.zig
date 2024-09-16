const std = @import("std");

pub const CommandErrors = error{UnknownCommand};

pub const Command = struct {
    name: []const u8,
    // parameters: []const Parameters,
    // arguments: []const Arguments,
    // options: []const Options,

    pub fn init(name: []const u8) Command {
        return Command{ .name = name };
    }
};