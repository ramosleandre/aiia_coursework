# Part 1B – Sudoku Solver

Backtracking search with forward checking and MRV.

## Requirements
Python 3.8+, no external library (`tkinter` comes with Python).

## How to run
From the `part_1` folder:
```bash
python game.py                        # GUI
python game.py puzzles/01_wikipedia.txt   # solve one puzzle in the terminal
python game.py puzzles/*              # solve all puzzles + results table
```

## Input
A `.txt` (spaces) or `.csv` (commas) file: 9 lines of 9 digits, `0` = empty cell.

## Techniques
Chosen with the menus in the GUI, in `SETTINGS` (`heuristics.py`),
or on the command line as `key=value`:
```python
SETTINGS = {
    "select": "mrv",     # "first", "mrv" or "mrv_advanced" (MRV + degree)
    "order": "default",  # "default" (1..9) or "lcv"
    "inference": "fc",   # "none" (plain backtracking) or "fc" (forward checking)
}
```

## Reproduce the results of the report
```bash
python benchmark.py > results.md   # every method, 3 runs each, average time (~15 min)
```
Steps and backtracks never change; the time changes a bit, so it is the average of 3 runs.
Plain BT is slow on puzzle 06 (built against backtracking): about 3 minutes per run.
To run one method only:
```bash
python game.py puzzles/* select=first inference=none   # plain BT
python game.py puzzles/* select=first                  # BT+FC
python game.py puzzles/*                               # BT+FC+MRV (our solver)
python game.py puzzles/* select=mrv_advanced           # BT+FC+MRV adv
python game.py puzzles/* order=lcv                     # BT+FC+MRV+LCV
```

## Files
| File | Role |
|---|---|
| `game.py` | entry point (terminal or GUI) |
| `gui.py` | Tkinter GUI |
| `sudoku_parser.py` | reads the puzzle files |
| `csp.py` | Sudoku as a CSP: variables, domains, constraints |
| `heuristics.py` | MRV, MRV advanced, LCV, forward checking + `SETTINGS` |
| `algo.py` | backtracking search |
| `benchmark.py` | runs every method 3 times, prints the results table |
| `puzzles/` | test puzzles (sources below) |

## Puzzles
| File | Givens | Source |
|---|---|---|
| `01_wikipedia.txt` | 30 | example puzzle of the Wikipedia article "Sudoku" |
| `02_norvig_grid1.txt` | 32 | `grid1` in P. Norvig, "Solving Every Sudoku Puzzle" |
| `03_norvig_top95_1.csv` | 17 | 1st puzzle of Norvig's `top95.txt` (hard puzzles) |
| `04_norvig_top95_2.txt` | 17 | 2nd puzzle of Norvig's `top95.txt` |
| `05_inkala_2012.txt` | 21 | A. Inkala's "world's hardest Sudoku" (2012), from sudokuwiki.org |
| `06_anti_backtracking.txt` | 17 | puzzle "designed to work against the brute force algorithm", Wikipedia "Sudoku solving algorithms" |
| `07_no_solution.txt` | 9 | made by us: cell (1,9) has no possible value |
| `08_invalid_givens.txt` | 31 | made by us: puzzle 01 with two 5s in the first row |
