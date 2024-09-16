pub const ArgumentErrors = error{ArgumentUnknown};

pub const Arguments = union(enum) { Text: ?[]u8, Int: ?i64, Float: ?f64 };

pub const CliArgument = struct {
    name: []u8,
    value: Arguments,
    optional: bool,

    pub fn init(name: []u8, value: Arguments, optional: bool) CliArgument {
        return CliArgument{ .name = name, .value = value, .optional = optional };
    }
};