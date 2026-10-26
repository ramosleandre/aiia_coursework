"""Tkinter GUI: load a puzzle, choose the techniques, click Solve."""
import os
import tkinter as tk
from tkinter import filedialog

from sudoku_parser import load_grid
from algo import solve
from heuristics import SETTINGS, method_name

PUZZLE_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "puzzles")
FONT = ("Helvetica", 20)
CHOICES = {
    "select": ["first", "mrv", "mrv_advanced"],
    "order": ["default", "lcv"],
    "inference": ["none", "fc"],
}


class SudokuGUI:
    def __init__(self, root):
        self.root = root
        root.title("Sudoku Solver")
        self.puzzle = [[0] * 9 for _ in range(9)]

        # examples + open file
        top = tk.Frame(root)
        top.pack(pady=5)
        self.examples = sorted(os.listdir(PUZZLE_DIR))
        self.choice = tk.StringVar(value="Choose an example")
        tk.OptionMenu(top, self.choice, *self.examples, command=self.load_example).pack(side="left")
        tk.Button(top, text="Open file...", command=self.open_file).pack(side="left", padx=5)

        # 3x3 boxes of 3x3 cells, the black gaps make the thick lines
        board = tk.Frame(root, bg="black", bd=2)
        board.pack(padx=10, pady=5)
        self.cells = [[None] * 9 for _ in range(9)]
        for br in range(3):
            for bc in range(3):
                box = tk.Frame(board, bg="grey")
                box.grid(row=br, column=bc, padx=2, pady=2)
                for i in range(3):
                    for j in range(3):
                        e = tk.Entry(box, width=2, font=FONT, justify="center", bd=0)
                        e.grid(row=i, column=j, padx=1, pady=1, ipady=4)
                        self.cells[3 * br + i][3 * bc + j] = e

        # one menu per setting
        options = tk.Frame(root)
        options.pack()
        self.options = {}
        for key, choices in CHOICES.items():
            tk.Label(options, text=key + ":").pack(side="left")
            self.options[key] = tk.StringVar(value=SETTINGS[key])
            tk.OptionMenu(options, self.options[key], *choices).pack(side="left")

        # buttons + status
        buttons = tk.Frame(root)
        buttons.pack(pady=5)
        tk.Button(buttons, text="Solve", command=self.on_solve).pack(side="left", padx=5)
        tk.Button(buttons, text="Reset", command=lambda: self.show(self.puzzle)).pack(side="left", padx=5)
        tk.Button(buttons, text="Clear", command=self.clear).pack(side="left", padx=5)
        self.status = tk.Label(root, text="Load a puzzle or type one in the grid.")
        self.status.pack(pady=5)

    def show(self, grid, solution=None):
        """Given digits in black, found digits in blue."""
        for r in range(9):
            for c in range(9):
                e = self.cells[r][c]
                e.delete(0, "end")
                if grid[r][c]:
                    e.insert(0, str(grid[r][c]))
                    e.config(fg="black")
                elif solution:
                    e.insert(0, str(solution[r][c]))
                    e.config(fg="blue")

    def read_grid(self):
        """Grid typed in the GUI, None if a cell is not valid."""
        grid = []
        for row in self.cells:
            values = []
            for e in row:
                text = e.get().strip()
                if text in ("", "0", "."):
                    values.append(0)
                elif len(text) == 1 and text in "123456789":
                    values.append(int(text))
                else:
                    return None
            grid.append(values)
        return grid

    def load(self, path):
        try:
            self.puzzle = load_grid(path)
        except (ValueError, OSError) as err:
            self.status.config(text=f"Error: {err}", fg="red")
            return
        self.show(self.puzzle)
        self.status.config(text=f"Loaded {os.path.basename(path)}", fg="black")

    def load_example(self, name):
        self.load(os.path.join(PUZZLE_DIR, name))

    def open_file(self):
        path = filedialog.askopenfilename(filetypes=[("Sudoku", "*.txt *.csv")])
        if path:
            self.load(path)

    def clear(self):
        self.puzzle = [[0] * 9 for _ in range(9)]
        self.show(self.puzzle)

    def on_solve(self):
        grid = self.read_grid()
        if grid is None:
            self.status.config(text="Invalid input: use digits 1-9 only.", fg="red")
            return
        self.puzzle = grid
        for key, var in self.options.items():
            SETTINGS[key] = var.get()
        solution, stats = solve(grid)
        info = f"{method_name()} | {stats['time_ms']:.2f} ms | steps: {stats['steps']} | backtracks: {stats['backtracks']}"
        if solution is None:
            self.status.config(text=f"No solution. ({info})", fg="red")
        else:
            self.show(grid, solution)
            self.status.config(text=f"Solved! {info}", fg="green")


def run():
    root = tk.Tk()
    SudokuGUI(root)
    root.mainloop()
