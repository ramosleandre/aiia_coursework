"""Sudoku as a CSP: variables, domains, constraints."""


# Constraints: a cell must be different from its 20 peers
# (same row, same column, same 3x3 box)

def get_peers(r, c):
    peers = set()
    for rr in range(9):
        for cc in range(9):
            same_row = rr == r
            same_col = cc == c
            same_box = rr // 3 == r // 3 and cc // 3 == c // 3
            if (rr, cc) != (r, c) and (same_row or same_col or same_box):
                peers.add((rr, cc))
    return peers


# computed only once !
PEERS = {(r, c): get_peers(r, c) for r in range(9) for c in range(9)}


def is_valid_start(grid):
    """False if two given digits already break a constraint."""
    for (r, c), peers in PEERS.items():
        v = grid[r][c]
        if v != 0:
            for pr, pc in peers:
                if grid[pr][pc] == v:
                    return False
    return True


# Variables: the empty cells

def get_variables(grid):
    return [(r, c) for r in range(9) for c in range(9) if grid[r][c] == 0]


# Domains: for each variable, the values not used by its peers

def init_domains(grid):
    domains = {}
    for var in get_variables(grid):
        used = {grid[r][c] for r, c in PEERS[var]}
        domains[var] = {d for d in range(1, 10) if d not in used}
    return domains
