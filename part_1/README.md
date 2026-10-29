# Part 1B - Sudoku Solver

Backtracking with forward checking (FC) and MRV.

## Requirements
- Python 3.8 or newer
- No external library (tkinter for the GUI comes with Python)
- No solver library is used

## How to run
From the `part_1` folder:

```bash
# GUI
python3 game.py

# solve one puzzle in the terminal
python3 game.py puzzles/05_inkala_2012.txt

# choose the techniques (here BT + MRV + LCV + FC)
python3 game.py select=mrv order=lcv inference=fc puzzles/05_inkala_2012.txt

# run every method on every puzzle (3 runs each, ~15 min)
python3 benchmark.py
```

Settings:
- `select` = `first`, `mrv` (default) or `mrv_advanced`
- `order` = `default` or `lcv`
- `inference` = `none` or `fc` (default)

## Input
`.txt` (spaces) or `.csv` (commas): 9 lines of 9 digits, `0` = empty cell.
Test puzzles are in `puzzles/`.
