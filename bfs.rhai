// the 8 painters find the closest different cell
fn colour() {
    worker(0).color;
}


fn find_next_pos(x, y, map) {
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
        
        if map[pos_x][pos_y] != colour() {
            
            let dest = mtrx[pos_x][pos_y];
            while (dest != [x, y]) {
                pos_x = dest[0];
                pos_y = dest[1];
                dest = mtrx[pos_x][pos_y];
            }
            
            return [pos_x, pos_y];

        } else {
            if (pos_x > 0 && mtrx[pos_x-1][pos_y] == [-1, -1]) {
                queue += [[pos_x-1, pos_y]];
                mtrx[pos_x-1][pos_y] = [pos_x, pos_y];
            }
            if (pos_x < 39 && mtrx[pos_x+1][pos_y] == [-1, -1]) {
                queue += [[pos_x+1, pos_y]];
                mtrx[pos_x+1][pos_y] = [pos_x, pos_y];
            }
            if (pos_y > 0 && mtrx[pos_x][pos_y-1] == [-1, -1]) {
                queue += [[pos_x, pos_y-1]];
                mtrx[pos_x][pos_y-1] = [pos_x, pos_y];
            }
            if (pos_y < 39 && mtrx[pos_x][pos_y+1] == [-1, -1]) {
                queue += [[pos_x, pos_y+1]];
                mtrx[pos_x][pos_y+1] = [pos_x, pos_y];
            }

            continue;
        }
    }
}


for w in 0..8 {
    let x = worker(w).x;
    let y = worker(w).y;

    let next_pos = find_next_pos(x, y, map);
    
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
    
    info(`worker ${w} finished`);
}