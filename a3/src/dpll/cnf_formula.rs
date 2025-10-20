pub type Variable = char;

#[derive(Clone,Debug,PartialEq,Eq)]
pub enum Atom {
    Base(Variable),
    Not(Variable)
}

pub type Clause = Vec<Atom>;

pub type Formula = Vec<Clause>;

pub fn has_var_clause(c:& Clause,v:Variable) -> bool {
    for a in c {
        match a {
            Atom::Base(vp) => 
                if *vp == v {
                    return true;
                }
            Atom::Not(vp) => 
                if *vp == v {
                    return true;
                }
        }
    }
    return false;
}

pub fn get_vars(f:& Formula) -> Vec<Variable> {
    let mut vs = Vec::new();
    for c in f {
        for a in c {
            match a {
                Atom::Base(v) => vs.push(*v),
                Atom::Not(v) => vs.push(*v)
            }
        }
    }
    vs.sort_unstable();
    vs.dedup();
    return vs;
}

pub fn is_pure(f:& Formula, v:Variable) -> bool {
    let mut polarities = Vec::new();
    for c in f {
        for a in c {
            match a {
                Atom::Base(i) =>
                    if *i == v {
                        polarities.push(true)
                    }
                Atom::Not(i) =>
                    if *i == v {
                        polarities.push(false)
                    }
            }
        }
    }
    polarities.dedup();
    if polarities.len() == 1 {
        return true;
    }
    else {
        return false;
    }
}