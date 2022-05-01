// 3 attack other players, 2 defend the original quarter and the rest find the closest different cell.
if "n_tick" in memory {
    memory.n_tick += 1;
} else {
    memory.set("n_tick", 0);
}
fn count_tiles(map) {
    let c = colour();
    let n_tiles = [[0, 0], [0, 0]];
    for x in 0..20 {
        for y in 20..40 {
            if map[x][y] != c {
                n_tiles[0][1] += 1;
            }
        }
        for y in 0..20 {
            if map[x][y] != c {
                n_tiles[0][0] += 1;
            }
        }
    }
    for x in 20..40 {
        for y in 20..40 {
            if map[x][y] != c {
                n_tiles[1][1] += 1;
            }
        }
        for y in 0..20 {
            if map[x][y] != c {
                n_tiles[1][0] += 1;
            }
        }
    }
    /*
    let c = colour();
    if c == Tile::BLUE {
        n_tiles["blue"] = 0;
    } else if c == Tile::GREEN {
        n_tiles["green"] = 0;
    }  else if c == Tile::YELLOW {
        n_tiles["yellow"] = 0;
    } else if c == Tile::RED {
        n_tiles["red"] = 0;
    }
    */
    return n_tiles;
}
fn get_quarter() {
    let pos_x = worker(7).x;
    let pos_y = worker(7).y;
    let half_x = 0;
    if pos_x >= 20 {
        half_x = 1;
    }
    let half_y = 0;
    if pos_y >= 20 {
        half_y = 1;
    }
    let half = [half_x, half_y];
    return half;
}
fn colour() {
    worker(0).color;
}
fn get_target(w, map) {
    let quarter = get_quarter();
    let action = switch quarter {
        [0,0] => "dl",
        [0,1] => "ul",
        [1,0] => "dr",
        [1,1] => "ur",
    };
    let zones = [];
    if action == "dl" {
        zones = switch w {
            0 => ["other","other"],
            1 => [1,1],
            2 => ["other","other"],
            3 => [0,1],
            4 => ["other","other"],
            5 => ["other","other"],
            6 => [1,0],
            7 => ["other","other"],
        }
    } else if action == "ul" {
        zones = switch w {
            0 => ["other","other"],
            1 => [1,1],
            2 => ["other","other"],
            3 => [0,0],
            4 => ["other","other"],
            5 => [1,0],
            6 => ["other","other"],
            7 => ["other","other"],
        }
    } else if action == "dr" {
        zones = switch w {
            0 => [0,0],
            1 => ["other","other"],
            2 => [0,1],
            3 => ["other","other"],
            4 => [1,1],
            5 => ["other","other"],
            6 => ["other","other"],
            7 => ["other","other"],
        }
    } else if action == "ur" {
        zones = switch w {
            0 => [0,0],
            1 => ["other","other"],
            2 => [0,1],
            3 => ["other","other"],
            4 => ["other","other"],
            5 => [1,0],
            6 => ["other","other"],
            7 => ["other","other"],
        }
    }
    let half_x = zones[0];
    let half_y = zones[1];
    if half_x == "other" {
        return "other"
    } else {
        return [half_x, half_y];
    }
}
fn get_limits(w) {
    if w in 0..6 {
        return [0, 39, 0, 39];
    }
    let quarter = get_quarter();
    let half_x = quarter[0];
    let half_y = quarter[1];
    return [half_x*20, (half_x+1)*20-1, half_y*20, (half_y+1)*20-1];
}
fn find_next_pos(w, x, y, map, n_tiles) {
    let mtrx = [];
    for i in 0..40 {
        let row = [];
        let cell = [-1, -1];
        row.pad(40, cell);
        mtrx += [row];
    }
    let queue = [[x, y]];
    while len(queue) > 0 {
        let first = queue.shift();
        let pos_x = first[0];
        let pos_y = first[1];
        let target = get_target(w, map);
        let in_limits = true;
        let number = 0;
        if target != "other" {
            let limits = [target[0]*20, (target[0]+1)*20-1, target[1]*20, (target[1]+1)*20-1];
            in_limits = (pos_x >= limits[0] && pos_x <= limits[1] && pos_y >= limits[2] && pos_y <= limits[3]);
            number = n_tiles[target[0]][target[1]];
        } else if w in 6..8 {
            let q = get_quarter();
            number = n_tiles[q[0]][q[1]];
        } else {
            number = n_tiles[0][0] + n_tiles[1][0] + n_tiles[0][1] + n_tiles[1][1];
        }
        if number == 0 {
            print("libre como el rapha");
        }
        if in_limits && (map[pos_x][pos_y] != colour() || number == 0) {
            //target reached
            print("target reached");
            let dest = mtrx[pos_x][pos_y];
            while (dest != [x, y]) {
                print([dest, [x, y]]);
                pos_x = dest[0];
                pos_y = dest[1];
                dest = mtrx[pos_x][pos_y];
            }
            print(["fi", [pos_x, pos_y], dest, [x, y]]);
            return [pos_x, pos_y];
        } else {
            let lim = get_limits(w);
            let dir = [1, 2, 3, 4];
            dir.shuffle();
            for dir_i in dir {
                let min_x = lim[0];
                let max_x = lim[1];
                let min_y = lim[2];
                let max_y = lim[3];
                if (dir_i == 1 && pos_x > min_x && mtrx[pos_x-1][pos_y] == [-1, -1]) {
                    queue += [[pos_x-1, pos_y]];
                    mtrx[pos_x-1][pos_y] = [pos_x, pos_y];
                }
                if (dir_i == 2 && pos_x < max_x && mtrx[pos_x+1][pos_y] == [-1, -1]) {
                    queue += [[pos_x+1, pos_y]];
                    mtrx[pos_x+1][pos_y] = [pos_x, pos_y];
                }
                if (dir_i == 3 && pos_y > min_y && mtrx[pos_x][pos_y-1] == [-1, -1]) {
                    queue += [[pos_x, pos_y-1]];
                    mtrx[pos_x][pos_y-1] = [pos_x, pos_y];
                }
                if (dir_i == 4 && pos_y < max_y && mtrx[pos_x][pos_y+1] == [-1, -1]) {
                    queue += [[pos_x, pos_y+1]];
                    mtrx[pos_x][pos_y+1] = [pos_x, pos_y];
                }
            }
            continue;
        }
    }
}
// print("memory.n_tick");
// print(memory.n_tick);
let n_tiles = count_tiles(map);
// print(n_tiles);
// print("counted");
for w in 0..8 {
    let x = worker(w).x;
    let y = worker(w).y;
    print(["find next pos from", w, [x, y]]);
    print(n_tiles);
    let next_pos = find_next_pos(w, x, y, map, n_tiles);
    print(["next pos given", next_pos]);
    if next_pos[0] == x {
        if next_pos[1] == y + 1 {
            worker(w).move_up();
        } else if next_pos[1] == y - 1 {
            worker(w).move_down();
        }
    } else {
        if next_pos[0] == x + 1 {
            worker(w).move_right();
        } else if next_pos[0] == x - 1 {
            worker(w).move_left();
        }
    }
    //info(`worker ${w} finished`);
}