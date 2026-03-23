const std = @import("std");

const Io = std.Io;

pub const Color = struct {
    red: u8,
    green: u8,
    blue: u8,


    pub fn init(red: u8, green: u8, blue: u8) Color {
        return .{
            .red = red,
            .green = green,
            .blue = blue,
        };
    }

    pub fn format(self: Color,  writer: *Io.Writer) !void {
        try writer.print("\x1b[38;2;{};{};{}m", .{self.red, self.green, self.blue});
    }
};

pub const MAUVE = Color.init(203, 166, 247);
pub const RED = Color.init(243, 139, 168);
pub const GREEN = Color.init(166, 227, 161);
pub const PEACH = Color.init(250, 179, 136);
pub const YELLOW = Color.init(249, 226, 175);
pub const SKY = Color.init(170, 200, 255);
pub const BLUE = Color.init(137, 137, 255);
pub const WHITE = Color.init(255, 255, 255);

