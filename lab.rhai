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
            0 => [39,39],
            1 => "other",
            2 => [0,39],
            3 => "other",
            4 => [0,39],
            5 => [39,0],
            6 => [39,0],
            7 => "other",
        }
    } else if action == "ul" {
        zones = switch w {
            0 => [0,0],
            1 => "other",
            2 => "other",
            3 => [0,0],
            4 => [39,39],
            5 => [39,0],
            6 => [39,39],
            7 => "other",
        }
    } else if action == "dr" {
        zones = switch w {
            0 => [0,0],
            1 => [0,0],
            2 => [0,39],
            3 => "other",
            4 => [39,39],
            5 => "other",
            6 => [39,39],
            7 => "other",
        }
    } else if action == "ur" {
        zones = switch w {
            0 => [0,0],
            1 => [0,39],
            2 => [0,39],
            3 => [39,0],
            4 => "other",
            5 => [39,0],
            6 => "other",
            7 => "other",
        }
    }
    return zones;
}

let z = get_target(0, map);
print(z);
print("-------------")