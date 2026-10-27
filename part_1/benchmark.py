"""Runs every method 3 times on every puzzle and prints a markdown table (for the report).

python benchmark.py                   -> all puzzles (~15 min, plain BT is slow)
python benchmark.py puzzles/0[1-5]*   -> only some puzzles
python benchmark.py > results.md      -> save the table
"""
import os
import sys

from sudoku_parser import load_grid
from algo import solve
from heuristics import SETTINGS, method_name

RUNS = 3

METHODS = [
    {"select": "first", "order": "default", "inference": "none"},        # BT
    {"select": "first", "order": "default", "inference": "fc"},          # BT+FC
    {"select": "mrv", "order": "default", "inference": "fc"},            # BT+FC+MRV
    {"select": "mrv_advanced", "order": "default", "inference": "fc"},   # BT+FC+MRV adv
    {"select": "mrv", "order": "lcv", "inference": "fc"},                # BT+FC+MRV+LCV
]

files = sys.argv[1:] or [os.path.join("puzzles", f) for f in sorted(os.listdir("puzzles"))]

print("| Puzzle | Method | Result | Time (ms) | Steps | Backtracks |")
print("|---|---|---|---|---|---|")
for path in files:
    grid = load_grid(path)
    for method in METHODS:
        SETTINGS.update(method)
        total_time = 0
        for _ in range(RUNS):
            solution, stats = solve(grid)
            total_time += stats["time_ms"]
        result = "solved" if solution else "no solution"
        print(f"| {os.path.basename(path)} | {method_name()} | {result} | {total_time / RUNS:.2f} "
              f"| {stats['steps']} | {stats['backtracks']} |", flush=True)
