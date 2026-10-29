"""The techniques used by backtrack(), chosen with SETTINGS.

var = a variable of the CSP = an empty cell (row, col)
"""
from csp import PEERS

SETTINGS = {
    "select": "mrv",     # "first", "mrv" or "mrv_advanced"
    "order": "default",  # "default" or "lcv"
    "inference": "fc",   # "none" or "fc"
}


# which variable next?

def first_empty(domains):
    return min(domains)


def mrv(domains):
    """Variable with the fewest values left."""
    return min(domains, key=lambda var: (len(domains[var]), var))


def mrv_advanced(domains):
    """MRV, and on a tie the variable with the most empty peers (degree heuristic)."""
    def score(var):
        empty_peers = sum(1 for p in PEERS[var] if p in domains)
        return (len(domains[var]), -empty_peers, var)
    return min(domains, key=score)


def select_unassigned_variable(domains):
    if SETTINGS["select"] == "mrv":
        return mrv(domains)
    if SETTINGS["select"] == "mrv_advanced":
        return mrv_advanced(domains)
    return first_empty(domains)


# which value first?

def lcv(var, values, domains):
    """Value that removes the fewest options from the empty peers first."""
    def conflicts(value):
        return sum(1 for p in PEERS[var] if p in domains and value in domains[p])
    return sorted(values, key=conflicts)


def order_domain_values(var, values, domains):
    if SETTINGS["order"] == "lcv":
        return lcv(var, values, domains)
    return sorted(values)


# is the value ok?

def is_consistent(grid, var, value):
    """Plain backtracking: no peer already has this value."""
    for r, c in PEERS[var]:
        if grid[r][c] == value:
            return False
    return True


def forward_check(var, value, domains, removed):
    """Remove value from the empty peers. False if one of them has nothing left."""
    for p in PEERS[var]:
        if p in domains and value in domains[p]:
            domains[p].remove(value)
            removed.append(p)
            if not domains[p]:
                return False
    return True


def inference(grid, var, value, domains, removed):
    if SETTINGS["inference"] == "fc":
        return forward_check(var, value, domains, removed)
    return is_consistent(grid, var, value)


def method_name():
    """e.g. 'BT+FC+MRV', shown in the results."""
    name = "BT"
    if SETTINGS["inference"] == "fc":
        name += "+FC"
    if SETTINGS["select"] == "mrv":
        name += "+MRV"
    if SETTINGS["select"] == "mrv_advanced":
        name += "+MRV adv"
    if SETTINGS["order"] == "lcv":
        name += "+LCV"
    return name
