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

pub fn InputHandler(reader: *Io.Reader, writer: *Io.Writer, block: bool) !UserInput {

    const tty_file = try fs.openFileAbsolute("/dev/tty", .{});
    defer tty_file.close();
    const tty_fd = tty_file.handle;

    var old_settings: posix.termios = undefined;
    old_settings = try posix.tcgetattr(tty_fd);

    var new_settings: posix.termios = old_settings;
    new_settings.lflag.ICANON = false;
    new_settings.lflag.ECHO = false;
    new_settings.cc[6] = if (block) 1 else 0; //VMIN
    new_settings.cc[5] = 0; //VTIME
    new_settings.lflag.ECHOE = false;

    _ = try posix.tcsetattr(tty_fd, posix.TCSA.NOW, new_settings);

    blk: while (true) {
        const c: u8 = reader.takeByte() catch |err| switch (err) {
            error.EndOfStream => {
                _ = try posix.tcsetattr(tty_fd, posix.TCSA.NOW, old_settings);
                return UserInput.Idle;
            },
            error.ReadFailed => {
                _ = try posix.tcsetattr(tty_fd, posix.TCSA.NOW, old_settings);
                return err;
            },
        };
        if (c == '\n') {
            _ = try posix.tcsetattr(tty_fd, posix.TCSA.NOW, old_settings);
            return UserInput.PauseButton;
        } else if (c == '\t') {
            _ = try posix.tcsetattr(tty_fd, posix.TCSA.NOW, old_settings);
            return UserInput.PauseButton;
        } else if (c == '\x7F') {
            continue: blk;
        } else if (c == '\x1B') {

            var char: u8 = reader.takeByte() catch |err| switch (err) {
                error.EndOfStream => {
                    _ = try posix.tcsetattr(tty_fd, posix.TCSA.NOW, old_settings);
                    return UserInput.ExitGameButton;
                },
                error.ReadFailed => {
                    _ = try posix.tcsetattr(tty_fd, posix.TCSA.NOW, old_settings);
                    return err;
                },
            };

            esc: switch (char) {
                '[' => {

                    char = reader.takeByte() catch |err| switch (err) {
                        error.EndOfStream => break: esc,
                        error.ReadFailed => return err,
                    };

                    switch (char) {

                        '3' => {
                            char = reader.takeByte() catch |err| switch (err) {
                                error.EndOfStream => break: esc,
                                error.ReadFailed => return err,
                            };
                            if (char == '~') {
                                continue: blk;
                            } else {
                                break: esc;
                            }
                        },

                        'A' => {
                            // Handle up arrow input
                            _ = try posix.tcsetattr(tty_fd, posix.TCSA.NOW, old_settings);
                            return UserInput.RotCWButton;//UpButton;
                        },

                        'B' => {
                            // Handle down arrow input
                            _ = try posix.tcsetattr(tty_fd, posix.TCSA.NOW, old_settings);
                            return UserInput.DownButton;
                        },

                        'C' => {
                            // Handle right arrow input
                            _ = try posix.tcsetattr(tty_fd, posix.TCSA.NOW, old_settings);
                            return UserInput.RightButton;
                        },

                        'D' => {
                            // Handle left arrow input
                            _ = try posix.tcsetattr(tty_fd, posix.TCSA.NOW, old_settings);
                            return UserInput.LeftButton;
                        },

                        'H' => {
                            // Handle Home key
                            continue: blk; 
                        },

                        'F' => {
                            // Handle End key
                            continue: blk;
                        },
                        '5' => continue: esc '~',
                        '6' => continue: esc '~',
                        '~' => break: esc,
                        else => try writer.print(
                            "failed to handle escape [: {c}", .{char}
                        ),
                    }

                    break: esc;

                },

                else => {
                    break: esc;
                },
            }
            _ = try posix.tcsetattr(tty_fd, posix.TCSA.NOW, old_settings);

        }
    }
}

