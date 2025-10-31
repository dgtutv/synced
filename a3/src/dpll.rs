pub mod cnf_formula;
use std::vec;

use cnf_formula::*;

pub fn find_propogatable(f: &Formula) -> Option<(Variable, bool)> {
    for clause in f {
        if clause.len() == 1 {
            match &clause[0] {
                /* pattern match single clause */
                Atom::Base(v) => return Some((*v, true)),
                Atom::Not(v) => return Some((*v, false)),
            }
        }
    }
    return None;
}

pub fn clause_contains(a: &Atom, f: &Clause) -> bool {
    for atom in f {
        if atom == a {
            return true;
        }
    }
    return false;
}

pub fn propogate_unit(f: &mut Formula, v: Variable, b: bool) {
    let mut new_formula: Formula = Vec::new();
    for clause in f.iter() {
        if (b && clause_contains(&Atom::Base(v), &clause))
            || (!b && clause_contains(&Atom::Not(v), &clause))
        {
            //Clause is already true, do not include
            continue;
        }
        let mut new_clause: Clause = Vec::new();
        for atom in clause {
            if b {
                //Base(v) is true, Not(v) is false
                if atom == &Atom::Not(v) {
                    //Remove false atom (ORed)
                    continue;
                } else {
                    new_clause.push(atom.clone())
                }
            } else {
                //Base(v) is false, Not(v) is true
                if atom == &Atom::Base(v) {
                    continue;
                } else {
                    new_clause.push(atom.clone());
                }
            }
        }
        new_formula.push(new_clause);
    }
    *f = new_formula;
}

pub fn find_pure_var(f: &Formula) -> Option<Variable> {
    let variables: Vec<Variable> = get_vars(f);
    for v in variables {
        if is_pure(f, v) {
            return Some(v);
        }
    }
    return None;
}

pub fn assign_pure_var(f: &mut Formula, v: Variable) {
    unimplemented!()
}

pub fn unit_propogate(f: &mut Formula) {
    match find_propogatable(f) {
        Option::None => return,
        Option::Some((v, b)) => {
            propogate_unit(f, v, b);
            unit_propogate(f)
        }
    }
}

pub fn assign_pure_vars(f: &mut Formula) {
    match find_pure_var(f) {
        Option::None => return,
        Option::Some(v) => {
            assign_pure_var(f, v);
            assign_pure_vars(f);
        }
    }
}

pub fn dpll(f: &mut Formula) -> bool {
    unimplemented!()
}
