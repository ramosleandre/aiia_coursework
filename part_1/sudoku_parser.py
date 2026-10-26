"""Reads a 9x9 grid from a .txt (spaces) or .csv (commas) file, 0 = empty."""


def load_grid(path):
    """List of 9 rows of 9 ints. ValueError if the file is not a valid grid."""
    grid = []
    with open(path) as f:
        for line in f:
            line = line.replace(",", " ").strip()  # csv -> same as txt
            if line:
                grid.append([int(x) for x in line.split()])

    if len(grid) != 9 or any(len(row) != 9 for row in grid):
        raise ValueError(f"{path}: the grid must be 9x9")
    if any(v < 0 or v > 9 for row in grid for v in row):
        raise ValueError(f"{path}: values must be between 0 and 9")
    return grid
