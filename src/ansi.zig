pub const TextColors = struct {
    pub const Black = "\x1b[30m";
    pub const Red = "\x1b[31m";
    pub const Green = "\x1b[32m";
    pub const Yellow = "\x1b[33m";
    pub const Blue = "\x1b[34m";
    pub const Magenta = "\x1b[35m";
    pub const Cyan = "\x1b[36m";
    pub const White = "\x1b[37m";
    pub const BrightBlack = "\x1b[90m";
    pub const BrightRed = "\x1b[91m";
    pub const BrightGreen = "\x1b[92m";
    pub const BrightYellow = "\x1b[93m";
    pub const BrightBlue = "\x1b[94m";
    pub const BrightMagenta = "\x1b[95m";
    pub const BrightCyan = "\x1b[96m";
    pub const BrightWhite = "\x1b[97m";
};

pub const BackgroundColors = struct {
    pub const Black = "\x1b[40m";
    pub const Red = "\x1b[41m";
    pub const Green = "\x1b[42m";
    pub const Yellow = "\x1b[43m";
    pub const Blue = "\x1b[44m";
    pub const Magenta = "\x1b[45m";
    pub const Cyan = "\x1b[46m";
    pub const White = "\x1b[47m";
    pub const BrightBlack = "\x1b[100m";
    pub const BrightRed = "\x1b[101m";
    pub const BrightGreen = "\x1b[102m";
    pub const BrightYellow = "\x1b[103m";
    pub const BrightBlue = "\x1b[104m";
    pub const BrightMagenta = "\x1b[105m";
    pub const BrightCyan = "\x1b[106m";
    pub const BrightWhite = "\x1b[107m";
};

pub const AnsiUtils = struct {
    pub const ResetColors = "\x1b[0m";
    pub const MoveStart = "\x1b[1G";
    pub const MoveLeft = "\x1b[{d}D";
    pub const MoveRight = "\x1b[{d}C";
    pub const MoveUp = "\x1b[{d}A";
    pub const MoveDown = "\x1b[{d}B";
    pub const ToColumn = "\x1b[{d}G";
    pub const ToPosition = "\x1b[{d};{d}H";
    pub const EraseLine = "\x1b[K";
};

// Print some text
// try stdout.print("This line will be erased in 2 seconds...\n", .{});
// try bw.flush(); // Don't forget to flush!

// // Sleep for 2 seconds (2000 milliseconds)
// std.time.sleep(2000 * std.time.ns_per_ms);

// // Move cursor to the start of the line then erase it
// try stdout.print("{s}{s}{s}", .{ MOVE_CURSOR_UP, MOVE_CURSOR_START, ERASE_LINE });
// try bw.flush(); // Don't forget to flush!

// // Print another line to show the previous one was erased
// try stdout.print("The previous line has been erased.\n", .{});
// try bw.flush(); // Don't forget to flush!

// Print text with foreground and background colors
// try stdout.print("{s}{s}{s}{s}\n", .{ RED_FOREGROUND, GREEN_BACKGROUND, "Red text on Green background", RESET });
// try stdout.print("{s}{s}{s}{s}\n", .{ GREEN_FOREGROUND, YELLOW_BACKGROUND, "Green text on Yellow background", RESET });
// try stdout.print("{s}{s}{s}{s}\n", .{ YELLOW_FOREGROUND, BLUE_BACKGROUND, "Yellow text on Blue background", RESET });
// try stdout.print("{s}{s}{s}{s}\n", .{ BLUE_FOREGROUND, RED_BACKGROUND, "Blue text on Red background", RESET });
