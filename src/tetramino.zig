
pub const Tetramino = union(enum) {
    I: I_piece,
    O: O_piece,
    J: J_piece,
    L: L_piece,
    T: T_piece,
    S: S_piece,
    Z: Z_piece,

    pub fn init(char: u8) Tetramino {
        return switch (char) {
            'I' => .{ .I = I_piece.init(1, 4)},
            'O' => .{ .O = O_piece.init(0, 4)},
            'J' => .{ .J = J_piece.init(1, 4)},
            'L' => .{ .L = L_piece.init(1, 4)},
            'T' => .{ .T = T_piece.init(1, 4)},
            'S' => .{ .S = S_piece.init(1, 4)},
            'Z' => .{ .Z = Z_piece.init(1, 4)},
            else => unreachable, 
        };
    }

    pub fn rot_CW(self: *Tetramino) void {
        switch (self.*) {
            .I => |*piece| piece.rot_CW(),
            .O => {},
            .J => |*piece| piece.rot_CW(),
            .L => |*piece| piece.rot_CW(),
            .T => |*piece| piece.rot_CW(),
            .S => |*piece| piece.rot_CW(),
            .Z => |*piece| piece.rot_CW(),
        }
    }

    pub fn rot_CCW(self: *Tetramino) void {
        switch (self.*) {
            .I => |*piece| piece.rot_CCW(),
            .O => {},
            .J => |*piece| piece.rot_CCW(),
            .L => |*piece| piece.rot_CCW(),
            .T => |*piece| piece.rot_CCW(),
            .S => |*piece| piece.rot_CCW(),
            .Z => |*piece| piece.rot_CCW(),
        }
    }

    pub fn move_down(self: *Tetramino) void {
        switch (self.*) {
            .I => |*piece| piece.move_down(),
            .O => |*piece| piece.move_down(),
            .J => |*piece| piece.move_down(),
            .L => |*piece| piece.move_down(),
            .T => |*piece| piece.move_down(),
            .S => |*piece| piece.move_down(),
            .Z => |*piece| piece.move_down(),
        }
    }

    pub fn move_left(self: *Tetramino) void {
        switch (self.*) {
            .I => |*piece| piece.move_left(),
            .O => |*piece| piece.move_left(),
            .J => |*piece| piece.move_left(),
            .L => |*piece| piece.move_left(),
            .T => |*piece| piece.move_left(),
            .S => |*piece| piece.move_left(),
            .Z => |*piece| piece.move_left(),
        }
    }

    pub fn move_right(self: *Tetramino) void {
        switch (self.*) {
            .I => |*piece| piece.move_right(),
            .O => |*piece| piece.move_right(),
            .J => |*piece| piece.move_right(),
            .L => |*piece| piece.move_right(),
            .T => |*piece| piece.move_right(),
            .S => |*piece| piece.move_right(),
            .Z => |*piece| piece.move_right(),
        }
    }

    pub fn get_blocks(self: *Tetramino) [4][2]usize {
        return switch (self.*) {
            .I => |*piece| piece.get_blocks(),
            .O => |*piece| piece.get_blocks(),
            .J => |*piece| piece.get_blocks(),
            .L => |*piece| piece.get_blocks(),
            .T => |*piece| piece.get_blocks(),
            .S => |*piece| piece.get_blocks(),
            .Z => |*piece| piece.get_blocks(),
        };
    }

    pub fn isOccupied(self: *Tetramino, col: usize, row: usize) bool {
        return switch (self.*) {
            .I => |*piece| piece.isOccupied(row, col),
            .O => |*piece| piece.isOccupied(row, col),
            .J => |*piece| piece.isOccupied(row, col),
            .L => |*piece| piece.isOccupied(row, col),
            .T => |*piece| piece.isOccupied(row, col),
            .S => |*piece| piece.isOccupied(row, col),
            .Z => |*piece| piece.isOccupied(row, col),
        };
    }

};

const Orientation = enum{
    Spawn,
    Clockwise,
    CounterClockwise,
    DoubleRotated,
};

pub fn GenericPiece(block_pos: [3][2]usize) type {
    return struct{
        const Self = @This();

        row: usize,
        col: usize,
        orientation: Orientation,
        block_pos: [3][2]usize,

        pub fn init(row: usize, col: usize) Self {
            var tmp_blk_pos: [3][2]usize = undefined;
            for (0..3) |i| {
                tmp_blk_pos[i][1] = col + block_pos[i][1] - 1;
                tmp_blk_pos[i][0] = row + block_pos[i][0] - 1;
            }
            return .{
                .row = row,
                .col = col,
                .orientation = .Spawn,
                .block_pos = tmp_blk_pos,
            };
        }

        pub fn rot_CW(self: *Self) void {
            var tmp_blk_pos: [3][2]usize = undefined;
            for (0..3) |i| {
                tmp_blk_pos[i][1] = self.col + self.row - self.block_pos[i][0];
                tmp_blk_pos[i][0] = self.block_pos[i][1] + self.row - self.col;
            }
            self.block_pos = tmp_blk_pos;
            switch (self.orientation) {
                .Spawn => {
                    self.orientation = .Clockwise;
                },
                .Clockwise => self.orientation = .DoubleRotated,
                .DoubleRotated => self.orientation = .CounterClockwise,
                .CounterClockwise => self.orientation = .Spawn,
            }
        }

        pub fn rot_CCW(self: *Self) void {
            var tmp_blk_pos: [3][2]usize = undefined;
            for (0..3) |i| {
                tmp_blk_pos[i][1] = self.block_pos[i][0] + self.col - self.row;
                tmp_blk_pos[i][0] = self.row + self.col - self.block_pos[i][1];
            }
            self.block_pos = tmp_blk_pos;
            switch (self.orientation) {
                .Spawn => self.orientation = .CounterClockwise,
                .Clockwise => self.orientation = .Spawn,
                .DoubleRotated => self.orientation = .Clockwise,
                .CounterClockwise => self.orientation = .DoubleRotated,
            }
        }

        pub fn move_down(self: *Self) void {
            self.row += 1;
            for (0..3) |i| {
                self.block_pos[i][0] += 1;
            }
        }

        pub fn move_left(self: *Self) void {
            self.col -= 1;
            for (0..3) |i| {
                self.block_pos[i][1] -= 1;
            }
        }

        pub fn move_right(self: *Self) void {
            self.col += 1;
            for (0..3) |i| {
                self.block_pos[i][1] += 1;
            }
        }

        pub fn get_blocks(self: *Self) [4][2]usize {
            return .{ 
                self.block_pos[0],
                .{self.row, self.col}, 
                self.block_pos[1],
                self.block_pos[2],
            };
        }

        pub fn isOccupied(self: *Self, col: usize, row: usize) bool {
            const blockpos = self.get_blocks();

            inline for (0..4) |i| {
                if ((blockpos[i][1] == col) and (blockpos[i][0] == row)) {
                    return true;
                }
            } else {
                return false;
            }
        }
    };
}

const I_piece = GenericPiece(.{ .{1, 0}, .{1, 2}, .{1, 3}}); // huh how? doesn't fit in 3 by 3
const O_piece = GenericPiece(.{ .{2, 1}, .{1, 2}, .{2, 2} });
const J_piece = GenericPiece(.{ .{0, 0}, .{1, 0}, .{1, 2} });
const L_piece = GenericPiece(.{ .{1, 0}, .{1, 2}, .{0, 2} });
const T_piece = GenericPiece(.{ .{1, 0}, .{0, 1}, .{1, 2} });
const Z_piece = GenericPiece(.{ .{0, 0}, .{0, 1}, .{1, 2} });
const S_piece = GenericPiece(.{ .{1, 0}, .{0, 1}, .{0, 2} });

