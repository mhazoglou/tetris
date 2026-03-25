const std = @import("std");
const builtin = std.builtin;
const Io = std.Io;
const posix = std.posix;
const fs = std.fs;
const File = fs.File;

pub const UserInput = enum{
    Idle,
    LeftButton,
    RightButton,
    DownButton,
    UpButton,
    RotCWButton,
    RotCCWButton,
    HardDropButton,
    PauseButton,
    ExitGameButton,
};

pub const is_posix: bool = switch (builtin.os.tag) {
    .windows, .uefi, .wasi => false,
    else => true,
};

pub const InputMapping = struct {
    left: []u8,
    right: []u8,
    soft_drop: []u8,
    hard_drop: []u8,
    hold: []u8,
    rotCW: []u8,
    rotCCW: []u8,
    pause: []u8,
    exit: []u8,
};

pub fn InputHandler(reader: *Io.Reader, writer: *Io.Writer) !UserInput {

    while (true) {
        const str: []u8 = reader.takeDelimiterExclusive(0) catch |err| switch (err) {
            error.EndOfStream => {
                return UserInput.Idle;
            },
            error.ReadFailed => {
                return err;
            },
            error.StreamTooLong => {
                return err;
            },
        };
        if (std.mem.eql(u8, str, "\n")) {
            return UserInput.PauseButton;
        }
        if (std.mem.eql(u8, str, "\t")) {
            return UserInput.PauseButton;
        }
        if (std.mem.eql(u8, str, " ")) {
            return UserInput.HardDropButton;
        }
        if (std.mem.eql(u8, str, "\x1B")) {
            return UserInput.ExitGameButton;
        }
        if (std.mem.eql(u8, str, "\x1B[A")) {
            return UserInput.UpButton;
        } 
        if (std.mem.eql(u8, str, "\x1B[B")) {
            return UserInput.DownButton;
        }
        if (std.mem.eql(u8, str, "\x1B[C")) {
            return UserInput.RightButton;
        }
        if (std.mem.eql(u8, str, "\x1B[D")) {
            return UserInput.LeftButton;
        } else {
            try writer.print("Unhandled", .{});
        }
        if (std.mem.eql(u8, str, "x")) {
            return UserInput.RotCWButton;
        }
        if (std.mem.eql(u8, str, "z")) {
            return UserInput.RotCCWButton;
        }
    }
}
