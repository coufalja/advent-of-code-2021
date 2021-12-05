use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;

#[derive(Debug)]
struct Item {
    value: u32,
    marked: bool,
}

#[derive(Debug)]
struct Board {
    items: Vec<Vec<Item>>,
}

impl Board {
    fn score(&self) -> u32 {
        let mut score = 0;
        for row in &self.items {
            for item in row {
                if !item.marked {
                    score += item.value;
                }
            }
        }
        score
    }

    fn won(&self) -> bool {
        for (i, row) in self.items.iter().enumerate() {
            let mut w_row = true;
            let mut w_col = true;
            for (j, _) in row.iter().enumerate() {
                w_row = w_row && self.items[i][j].marked;
                w_col = w_col && self.items[j][i].marked;
            }
            if w_row || w_col {
                return true;
            }
        }
        return false;
    }

    fn mark(&mut self, turn: u32) {
        for row in self.items.iter_mut() {
            for item in row {
                if item.value == turn {
                    item.marked = true;
                }
            }
        }
    }
}

fn main() {
    let mut turns: Vec<u32> = Vec::new();
    let mut boards: Vec<Board> = Vec::new();
    if let Ok(lines) = read_lines("../input.txt") {
        let mut i = 0;
        let mut current = Board { items: Vec::new() };
        for line in lines {
            if let Ok(ll) = line {
                i += 1;
                if i == 1 {
                    turns.extend(
                        ll.split(",")
                            .collect::<Vec<&str>>()
                            .iter()
                            .map(|x| x.parse::<u32>().unwrap())
                            .collect::<Vec<u32>>(),
                    );
                    continue;
                }
                if ll == "" {
                    if i != 2 {
                        boards.push(current);
                        current = Board { items: Vec::new() };
                    }
                    continue;
                }
                current.items.push(
                    ll.split_whitespace()
                        .collect::<Vec<&str>>()
                        .iter()
                        .map(|x| x.parse::<u32>().unwrap())
                        .map(|x| Item {
                            value: x,
                            marked: false,
                        })
                        .collect::<Vec<Item>>(),
                );
            }
        }
    }

    for turn in turns {
        for board in boards.iter_mut() {
            if board.won() {
                continue;
            }
            board.mark(turn);
            if board.won() {
                println!(
                    "Board won, winning number is: {} and board sum is : {}",
                    turn,
                    board.score()
                );
            }
        }
    }
}

fn read_lines<P>(filename: P) -> io::Result<io::Lines<io::BufReader<File>>>
where
    P: AsRef<Path>,
{
    let file = File::open(filename)?;
    Ok(io::BufReader::new(file).lines())
}
