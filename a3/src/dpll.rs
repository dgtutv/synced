pub mod cnf_formula;
use cnf_formula::*;

pub fn find_propogatable(f:& Formula) -> Option<(Variable,bool)> {
    unimplemented!()
}

pub fn propogate_unit(f:& mut Formula,v:Variable,b:bool) {
    unimplemented!()
}

pub fn find_pure_var(f:& Formula) -> Option<Variable> {
    unimplemented!()
}

pub fn assign_pure_var(f: & mut Formula, v: Variable) {
    unimplemented!()
}

pub fn unit_propogate(f:& mut Formula) {
    match find_propogatable(f) {
        Option::None => return,
        Option::Some((v,b)) => {
            propogate_unit(f, v, b);
            unit_propogate(f)
        }
    }
}

pub fn assign_pure_vars(f:& mut Formula) {
    match find_pure_var(f) {
        Option::None => return,
        Option::Some(v) => {
            assign_pure_var(f,v);
            assign_pure_vars(f); 
        }
    }
}

pub fn dpll(f:& mut Formula) -> bool {
    unimplemented!()
}