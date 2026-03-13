
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
            'I' => .{ .I = I_piece.init(1, 4, .{ .{1, 0}, .{1, 2}, .{1, 3} })},
            'O' => .{ .O = O_piece.init(0, 4, .{ .{2, 1}, .{1, 2}, .{2, 2} })},
            'J' => .{ .J = J_piece.init(1, 4, .{ .{0, 0}, .{1, 0}, .{1, 2} })},
            'L' => .{ .L = L_piece.init(1, 4, .{ .{1, 0}, .{1, 2}, .{0, 2} })},
            'T' => .{ .T = T_piece.init(1, 4, .{ .{1, 0}, .{0, 1}, .{1, 2} })},
            'S' => .{ .S = S_piece.init(1, 4, .{ .{1, 0}, .{0, 1}, .{0, 2} })},
            'Z' => .{ .Z = Z_piece.init(1, 4, .{ .{0, 0}, .{0, 1}, .{1, 2} })},
            else => unreachable, 
        };
    }

    pub fn rot_CW(self: *Tetramino, wall_kick: [2]isize) void {
        switch (self.*) {
            .I => |*piece| piece.rot_CW(wall_kick),
            .O => {},
            .J, .L, .T, .S, .Z => |*piece| piece.rot_CW(wall_kick),
        }
    }

    pub fn rot_CCW(self: *Tetramino, wall_kick: [2]isize) void {
        switch (self.*) {
            .I => |*piece| piece.rot_CCW(wall_kick),
            .O => {},
            .J, .L, .T, .S, .Z => |*piece| piece.rot_CCW(wall_kick),
        }
    }

    pub fn move_down(self: *Tetramino) void {
        switch (self.*) {
            .I, .O, .J, .L, .T, .S, .Z => |*piece| piece.move_down(),
        }
    }

    pub fn move_left(self: *Tetramino) void {
        switch (self.*) {
            .I, .O, .J, .L, .T, .S, .Z => |*piece| piece.move_left(),
        }
    }

    pub fn move_right(self: *Tetramino) void {
        switch (self.*) {
            .I, .O, .J, .L, .T, .S, .Z => |*piece| piece.move_right(),
        }
    }

    pub fn get_blocks(self: *Tetramino) [4][2]usize {
        return switch (self.*) {
            .I, .O, .J, .L, .T, .S, .Z => |*piece| piece.get_blocks(),
        };
    }

    pub fn isOccupied(self: *Tetramino, col: usize, row: usize) bool {
        return switch (self.*) {
            .I, .O, .J, .L, .T, .S, .Z => |*piece| piece.isOccupied(row, col),
        };
    }

// J, L, S, T, Z Tetromino Wall Kick Data
//           Test 1    Test 2    Test 3    Test 4    Test 5
// 0->R .{ .{ 0, 0}, .{0, -1}, .{ 1,-1}, .{-2, 0}, .{-2,-1} }
// R->2 .{ .{ 0, 0}, .{0,  1}, .{-1, 1}, .{ 2, 0}, .{ 2, 1} }
// L->0 .{ .{ 0, 0}, .{0, -1}, .{-1,-1}, .{ 2, 0}, .{ 2,-1} }
// 2->L .{ .{ 0, 0}, .{0,  1}, .{ 1, 1}, .{-2, 0}, .{-2, 1} }
// 0->L .{ .{ 0, 0}, .{0,  1}, .{ 1, 1}, .{-2, 0}, .{-2, 1} }
// R->0 .{ .{ 0, 0}, .{0,  1}, .{-1, 1}, .{ 2, 0}, .{ 2, 1} }
// L->2 .{ .{ 0, 0}, .{0, -1}, .{-1,-1}, .{ 2, 0}, .{ 2,-1} }
// 2->R .{ .{ 0, 0}, .{0, -1}, .{ 1,-1}, .{-2, 0}, .{-2,-1} }

//     I Tetromino Wall Kick Data
//           Test 1    Test 2    Test 3    Test 4    Test 5
// 0->R .{ .{ 0, 0}, .{ 0,-2}, .{ 0, 1}, .{-1,-2}, .{ 2, 1} }
// R->2 .{ .{ 0, 0}, .{ 0,-1}, .{ 0, 2}, .{ 2,-1}, .{-1, 2} } 
// L->0 .{ .{ 0, 0}, .{ 0, 1}, .{ 0,-2}, .{-2, 1}, .{ 1,-2} } 
// 2->L .{ .{ 0, 0}, .{ 0, 2}, .{ 0,-1}, .{ 1, 2}, .{-2,-1} } 
// 0->L .{ .{ 0, 0}, .{ 0,-1}, .{ 0, 2}, .{ 2,-1}, .{-1, 2} } 
// R->0 .{ .{ 0, 0}, .{ 0, 2}, .{ 0,-1}, .{ 1, 2}, .{-2,-1} } 
// L->2 .{ .{ 0, 0}, .{ 0,-2}, .{ 0, 1}, .{-1,-2}, .{ 2, 1} } 
// 2->R .{ .{ 0, 0}, .{ 0, 1}, .{ 0,-2}, .{-2, 1}, .{ 1,-2} } 

    pub fn wallKickCW(self: *Tetramino) [5][2]isize {
        return switch (self.*) {
            .I => |piece| {
                return switch (piece.orientation) {
                    .Spawn =>            .{ .{ 0, 0}, .{ 0,-2}, .{ 0, 1}, .{-1,-2}, .{ 2, 1} },
                    .Clockwise =>        .{ .{ 0, 0}, .{ 0,-1}, .{ 0, 2}, .{ 2,-1}, .{-1, 2} },
                    .CounterClockwise => .{ .{ 0, 0}, .{ 0, 1}, .{ 0,-2}, .{-2, 1}, .{ 1,-2} },
                    .DoubleRotated =>    .{ .{ 0, 0}, .{ 0, 2}, .{ 0,-1}, .{ 1, 2}, .{-2,-1} },
                };
            },
            .O => return .{ .{0} ** 2 } ** 5,
            .J, .L, .T, .S, .Z => |piece| {
                return switch (piece.orientation) {
                    .Spawn =>            .{ .{ 0, 0}, .{0, -1}, .{ 1,-1}, .{-2, 0}, .{-2,-1} },
                    .Clockwise =>        .{ .{ 0, 0}, .{0,  1}, .{-1, 1}, .{ 2, 0}, .{ 2, 1} },
                    .CounterClockwise => .{ .{ 0, 0}, .{0, -1}, .{-1,-1}, .{ 2, 0}, .{ 2,-1} },
                    .DoubleRotated =>    .{ .{ 0, 0}, .{0,  1}, .{ 1, 1}, .{-2, 0}, .{-2, 1} },
                };
            },
        };
    }

    pub fn wallKickCCW(self: *Tetramino) [5][2]isize {
        return switch (self.*) {
            .I => |piece| {
                return switch (piece.orientation) {
                    .Spawn =>            .{ .{ 0, 0}, .{ 0,-1}, .{ 0, 2}, .{ 2,-1}, .{-1, 2} },
                    .Clockwise =>        .{ .{ 0, 0}, .{ 0, 2}, .{ 0,-1}, .{ 1, 2}, .{-2,-1} },
                    .CounterClockwise => .{ .{ 0, 0}, .{ 0,-2}, .{ 0, 1}, .{-1,-2}, .{ 2, 1} },
                    .DoubleRotated =>    .{ .{ 0, 0}, .{ 0, 1}, .{ 0,-2}, .{-2, 1}, .{ 1,-2} },
                };
            },
            .O => .{ .{0} ** 2 } ** 5,
            .J, .L, .T, .S, .Z => |piece| {
                return switch (piece.orientation) {
                    .Spawn =>            .{ .{ 0, 0}, .{0,  1}, .{ 1, 1}, .{-2, 0}, .{-2, 1} },
                    .Clockwise =>        .{ .{ 0, 0}, .{0,  1}, .{-1, 1}, .{ 2, 0}, .{ 2, 1} },
                    .CounterClockwise => .{ .{ 0, 0}, .{0, -1}, .{-1,-1}, .{ 2, 0}, .{ 2,-1} },
                    .DoubleRotated =>    .{ .{ 0, 0}, .{0, -1}, .{ 1,-1}, .{-2, 0}, .{-2,-1} },
                };
            },
        };
    }

};

pub const Orientation = enum{
    Spawn,
    Clockwise,
    CounterClockwise,
    DoubleRotated,
};

pub fn GenericPiece() type {
    return struct{
        const Self = @This();

        row: usize,
        col: usize,
        orientation: Orientation,
        block_pos: [3][2]usize,

        pub fn init(row: usize, col: usize, block_pos: [3][2]usize) Self {
            var tmp_blk_pos: [3][2]usize = undefined;
            for (0..tmp_blk_pos.len) |i| {
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

        pub fn rot_CW(self: *Self, wall_kick: [2]isize) void {
            var tmp_blk_pos: [3][2]usize = undefined;
            for (0..tmp_blk_pos.len) |i| {
                tmp_blk_pos[i][1] = u_plus_i(
                    self.col + self.row - self.block_pos[i][0],
                    wall_kick[1]
                );
                tmp_blk_pos[i][0] = u_plus_i(
                    self.block_pos[i][1] + self.row - self.col,
                    wall_kick[0]
                );
            }
            self.row = u_plus_i(self.row, wall_kick[0]);
            self.col = u_plus_i(self.col, wall_kick[1]);
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

        pub fn rot_CCW(self: *Self, wall_kick: [2]isize) void {
            var tmp_blk_pos: [3][2]usize = undefined;
            for (0..tmp_blk_pos.len) |i| {
                tmp_blk_pos[i][1] = u_plus_i(
                    self.block_pos[i][0] + self.col - self.row,
                    wall_kick[1]
                );
                tmp_blk_pos[i][0] = u_plus_i(
                    self.row + self.col - self.block_pos[i][1], wall_kick[0]
                );
            }
            self.row = u_plus_i(self.row, wall_kick[0]);
            self.col = u_plus_i(self.col, wall_kick[1]);
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
            for (0..self.block_pos.len) |i| {
                self.block_pos[i][0] += 1;
            }
        }

        pub fn move_left(self: *Self) void {
            self.col -= 1;
            for (0..self.block_pos.len) |i| {
                self.block_pos[i][1] -= 1;
            }
        }

        pub fn move_right(self: *Self) void {
            self.col += 1;
            for (0..self.block_pos.len) |i| {
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

            inline for (0..blockpos.len) |i| {
                if ((blockpos[i][1] == col) and (blockpos[i][0] == row)) {
                    return true;
                }
            } else {
                return false;
            }
        }
    };
}

const I_piece = GenericPiece();
const O_piece = GenericPiece();
const J_piece = GenericPiece();
const L_piece = GenericPiece();
const T_piece = GenericPiece();
const S_piece = GenericPiece();
const Z_piece = GenericPiece();

pub fn u_plus_i(u: usize, i: isize) usize {
    var nu: usize = u;
    if (i < 0) {
        nu -= @intCast(-i);
    } else {
        nu += @intCast(i);
    }
    return nu;
}
