
import os
import sys

from sudoku_parser import load_grid
from algo import solve
from heuristics import SETTINGS, method_name


def print_grid(grid):
    for r in range(9):
        if r in (3, 6):
            print("------+-------+------")
        row = ""
        for c in range(9):
            if c in (3, 6):
                row += "| "
            row += (str(grid[r][c]) if grid[r][c] else ".") + " "
        print(row)


def print_table(results):
    print(f"{'Puzzle':<26}{'Method':<20}{'Result':<13}{'Time (ms)':>10}{'Steps':>10}{'Backtracks':>12}")
    print("-" * 91)
    for name, method, result, stats in results:
        print(f"{name:<26}{method:<20}{result:<13}{stats['time_ms']:>10.2f}{stats['steps']:>10}{stats['backtracks']:>12}")


def solve_file(path):
    """Solve and print one file, return its line for the table (None if bad file)."""
    name = os.path.basename(path)
    try:
        grid = load_grid(path)
    except (ValueError, OSError) as err:
        print(f"Error: {err}\n")
        return None

    solution, stats = solve(grid)
    print(f"=== {name} ===")
    print_grid(grid)
    if solution:
        print("\nSolution:")
        print_grid(solution)
    else:
        print("\nNo solution.")
    print()
    return name, method_name(), "solved" if solution else "no solution", stats


if __name__ == "__main__":
    if len(sys.argv) == 1:
        from gui import run
        run()
    else:
        files = []
        for arg in sys.argv[1:]:
            if "=" in arg:  # e.g. select=first, changes SETTINGS
                key, value = arg.split("=")
                if key not in SETTINGS  :
                    sys.exit(f"Unknown setting '{key}' (use select, order or inference)")
                SETTINGS[key] = value
            else:
                files.append(arg)

        results = []
        for path in files:
            line = solve_file(path)
            if line:
                results.append(line)
        print_table(results)
