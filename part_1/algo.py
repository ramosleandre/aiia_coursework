"""Backtracking search (same structure as the BACKTRACK pseudo-code)."""
import time

from csp import is_valid_start, init_domains
from heuristics import select_unassigned_variable, order_domain_values, inference


def backtrack(grid, domains, stats):
    """domains only holds the unassigned variables. Fills grid, True if solved."""
    if not domains:
        return True

    var = select_unassigned_variable(domains)
    values = domains.pop(var)
    r, c = var

    for value in order_domain_values(var, values, domains):
        stats["steps"] += 1
        grid[r][c] = value
        removed = []  # peers pruned by forward checking

        if inference(grid, var, value, domains, removed) and backtrack(grid, domains, stats):
            return True

        # undo and try the next value
        for p in removed:
            domains[p].add(value)
        stats["backtracks"] += 1

    # nothing works -> go back to the previous variable
    grid[r][c] = 0
    domains[var] = values
    return False


def solve(grid):
    """Returns (solution or None, stats). Does not change the input grid."""
    stats = {"steps": 0, "backtracks": 0, "time_ms": 0.0}
    start = time.perf_counter()

    grid = [row[:] for row in grid]
    solved = is_valid_start(grid) and backtrack(grid, init_domains(grid), stats)

    stats["time_ms"] = (time.perf_counter() - start) * 1000
    return (grid if solved else None), stats
