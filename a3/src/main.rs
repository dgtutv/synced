mod dpll;

fn get_user_input() -> String {
    use std::io::{stdin,stdout,Write};
    let _ = stdout().flush();
    let mut s = String::new();
    match stdin().read_line(&mut s) {
        Ok(_goes_into_input_above) => {},
        Err(_no_updates_is_fine) => {},
    }
    return s.trim().to_string();
}

fn get_atom() -> dpll::cnf_formula::Atom {
    println!("What variable do you want to input? (single char only)");
    let s = get_user_input().chars().nth(0).unwrap();
    println!("Do you want the atom to not be a negation? (n for negation)");
    let n = get_user_input() == "n";
    if n {
        dpll::cnf_formula::Atom::Not(s)
    } else {
        dpll::cnf_formula::Atom::Base(s)
    }
}

fn get_clause() -> dpll::cnf_formula::Clause {
    println!("Building a clause!");
    let mut c = Vec::new();
    let mut cont = true;
    while cont  {
        let b = get_atom();
        c.push(b);
        println!("Your current clause is {:?}",&c);
        println!("Do you want to input another atom? (y for yes, otherwise no)");
        cont = get_user_input() == "y";
    }
    return c;
}

fn main() {
    println!("CMPT383 DPLL SAT SOLVER!");
    let mut f = Vec::new();
    let mut cont = true;
    while cont  {
        let l = get_clause();
        f.push(l);
        println!("Your current formula is {:?}",&f);
        println!("Do you want to input another clause? (y for yes, otherwise no)");
        cont = get_user_input() == "y";
    }
    if dpll::dpll(& mut f) {
        println!("Your formula was satisfiable!")
    } else {
        println!("Your formula was not satisfiable!")
    }
}

#[cfg(test)]
mod find_propogatable_tests {
    use crate::dpll::find_propogatable;
    use crate::dpll::cnf_formula::Atom;

    #[test]
    fn find_propogatable_basic_0() {
        assert_eq!(Option::Some(('a',true))
                  ,find_propogatable (&vec![vec![Atom::Base('a')],vec![Atom::Not('a'),Atom::Base('c')]]))
    }

    #[test]
    fn find_propogatable_basic_1() {
        assert_eq!(Option::Some(('a',false))
                  ,find_propogatable (&vec![vec![Atom::Not('a')],vec![Atom::Base('b'),Atom::Not('c')]]))
    }

    #[test]
    fn find_propogatable_basic_2() {
        assert_eq!(Option::Some(('a',true))
                  ,find_propogatable (&vec![vec![Atom::Not('a'),Atom::Base('c')],vec![Atom::Base('a')]]))
    }

    #[test]
    fn find_propogatable_basic_3() {
        assert_eq!(Option::Some(('a',false))
                  ,find_propogatable (&vec![vec![Atom::Base('b'),Atom::Not('c')],vec![Atom::Not('a')]]))
    }

    #[test]
    fn find_propogatable_basic_4() {
        assert_eq!(Option::None
                  ,find_propogatable (&vec![vec![Atom::Base('b'),Atom::Base('c')]]))
    }

    #[test]
    fn find_propogatable_basic_5() {
        assert_eq!(Option::None
                  ,find_propogatable (&vec![vec![Atom::Base('b'),Atom::Base('c')],vec![Atom::Not('b'),Atom::Not('c')]]))
    }
}

#[cfg(test)]
mod propogate_unit_tests {
    use crate::dpll::propogate_unit;
    use crate::dpll::cnf_formula::Atom;

    #[test]
    fn propogate_unit_basic_0() {
        let mut f = vec![vec![Atom::Base('a')],vec![Atom::Not('a'),Atom::Base('c')]];
        propogate_unit(& mut f, 'a', true);
        assert_eq!(vec![vec![Atom::Base('c')]],f);
    }

    #[test]
    fn propogate_unit_basic_1() {
        let mut f = vec![vec![Atom::Not('a')],vec![Atom::Base('b'),Atom::Not('c')]];
        propogate_unit(& mut f, 'a', false);
        assert_eq!(vec![vec![Atom::Base('b'),Atom::Not('c')]],f);
    }

    #[test]
    fn propogate_unit_basic_2() {
        let mut f = vec![vec![Atom::Base('a')],vec![Atom::Not('a'),Atom::Base('c')],vec![Atom::Not('a')]];
        propogate_unit(& mut f, 'a', true);
        assert_eq!(vec![vec![Atom::Base('c')],vec![]],f);
    }

    #[test]
    fn propogate_unit_basic_3() {
        let mut f = vec![vec![Atom::Not('a')],vec![Atom::Base('b'),Atom::Not('c')],vec![Atom::Base('a')]];
        propogate_unit(& mut f, 'a', false);
        assert_eq!(vec![vec![Atom::Base('b'),Atom::Not('c')],vec![]],f);
    }

    #[test]
    fn propogate_unit_basic_4() {
        let mut f = vec![vec![Atom::Base('a')],vec![Atom::Not('a'),Atom::Base('c')],vec![Atom::Base('b'),Atom::Base('a')]];
        propogate_unit(& mut f, 'a', true);
        assert_eq!(vec![vec![Atom::Base('c')]],f);
    }

    #[test]
    fn propogate_unit_basic_5() {
        let mut f = vec![vec![Atom::Not('a')],vec![Atom::Base('b'),Atom::Not('c')],vec![Atom::Not('b'),Atom::Not('a')]];
        propogate_unit(& mut f, 'a', false);
        assert_eq!(vec![vec![Atom::Base('b'),Atom::Not('c')]],f);
    }

    #[test]
    fn propogate_unit_many_args() {
        let mut f = vec![vec![Atom::Not('a')],vec![Atom::Base('b'),Atom::Not('c'),Atom::Not('a')],vec![Atom::Not('b'),Atom::Not('a')],vec![Atom::Not('a'),Atom::Base('a')],vec![Atom::Not('b'),Atom::Base('a')]];
        propogate_unit(& mut f, 'a', false);
        assert_eq!(vec![vec![Atom::Not('b')]],f);
    }

    #[test]
    fn propogate_unit_many_args_dual() {
        let mut f = vec![vec![Atom::Base('a')],vec![Atom::Not('b'),Atom::Base('c'),Atom::Base('a')],vec![Atom::Base('b'),Atom::Base('a')],vec![Atom::Base('a'),Atom::Not('a')],vec![Atom::Base('b'),Atom::Not('a')]];
        propogate_unit(& mut f, 'a', true);
        assert_eq!(vec![vec![Atom::Base('b')]],f);
    }
}

#[cfg(test)]
mod find_pure_var_tests {
    use crate::dpll::find_pure_var;
    use crate::dpll::cnf_formula::Atom;

    #[test]
    fn find_pure_var_basic_0() {
        assert_eq!(Option::Some('a')
                  ,find_pure_var (&vec![vec![Atom::Base('a'),Atom::Base('b')],vec![Atom::Base('a'),Atom::Not('c')],vec![Atom::Not('b'),Atom::Base('c')]]))
    }

    #[test]
    fn find_pure_var_basic_1() {
        assert_eq!(Option::Some('a')
                  ,find_pure_var (&vec![vec![Atom::Not('a'),Atom::Not('b')],vec![Atom::Not('a'),Atom::Base('c')],vec![Atom::Base('b'),Atom::Not('c')]]))
    }

    #[test]
    fn find_pure_var_basic_2() {
        assert_eq!(Option::Some('b')
                  ,find_pure_var (&vec![vec![Atom::Not('a'),Atom::Base('b'),Atom::Base('b')],vec![Atom::Base('a'),Atom::Base('c')],vec![Atom::Base('b'),Atom::Not('c')]]));
    }

    #[test]
    fn find_pure_var_basic_3() {
        assert_eq!(Option::None
                  ,find_pure_var (&vec![vec![Atom::Base('a'),Atom::Not('b')],vec![Atom::Not('a'),Atom::Base('b')]]))
    }
}

#[cfg(test)]
mod assign_pure_var_tests {
    use crate::dpll::assign_pure_var;
    use crate::dpll::cnf_formula::Atom;

    #[test]
    fn assign_pure_var_basic_0() {
        let mut f = vec![vec![Atom::Base('a'),Atom::Base('b')],vec![Atom::Base('a'),Atom::Not('c')],vec![Atom::Not('b'),Atom::Base('c')]];
        assign_pure_var(& mut f, 'a');
        assert_eq!(vec![vec![Atom::Not('b'),Atom::Base('c')]],f);
    }

    #[test]
    fn assign_pure_var_basic_1() {
        let mut f = vec![vec![Atom::Not('a'),Atom::Not('b')],vec![Atom::Not('a'),Atom::Base('c')],vec![Atom::Base('b'),Atom::Not('c')]];
        assign_pure_var(& mut f, 'a');
        assert_eq!(vec![vec![Atom::Base('b'),Atom::Not('c')]],f);
    }

    #[test]
    fn assign_pure_var_basic_2() {
        let mut f = vec![vec![Atom::Base('a'),Atom::Base('b')],vec![Atom::Base('a'),Atom::Not('c')],vec![Atom::Not('b'),Atom::Base('c')],vec![Atom::Base('a')]];
        assign_pure_var(& mut f, 'a');
        assert_eq!(vec![vec![Atom::Not('b'),Atom::Base('c')]],f);
    }

    #[test]
    fn assign_pure_var_basic_3() {
        let mut f = vec![vec![Atom::Not('a'),Atom::Not('b')],vec![Atom::Not('a'),Atom::Base('c')],vec![Atom::Base('b'),Atom::Not('c')],vec![Atom::Base('z')]];
        assign_pure_var(& mut f, 'a');
        assert_eq!(vec![vec![Atom::Base('b'),Atom::Not('c')],vec![Atom::Base('z')]],f);
    }
}

#[cfg(test)]
mod dpll_tests {
    use crate::dpll::dpll;
    use crate::dpll::cnf_formula::Atom;

    #[test]
    fn dpll_basic_0() {
        assert_eq!(true,dpll(& mut vec![vec![Atom::Base('a'),Atom::Base('b')],vec![Atom::Base('a'),Atom::Not('c')],vec![Atom::Not('b'),Atom::Base('c')]]));
    }

    #[test]
    fn dpll_basic_1() {
        assert_eq!(true,dpll(& mut vec![vec![Atom::Base('a')],vec![Atom::Not('a'),Atom::Base('c')]]));
    }

    #[test]
    fn dpll_basic_2() {
        assert_eq!(true,dpll(& mut vec![vec![Atom::Base('a'),Atom::Base('b')],vec![Atom::Base('a'),Atom::Not('c')],vec![Atom::Not('b'),Atom::Base('c')]]));
    }

    #[test]
    fn dpll_basic_3() {
        assert_eq!(true,dpll(& mut vec![vec![Atom::Base('b'),Atom::Base('c')]]));
    }

    #[test]
    fn dpll_basic_4() {
        assert_eq!(true,dpll(& mut vec![vec![Atom::Base('a'),Atom::Base('b')],vec![Atom::Base('a'),Atom::Not('c')],vec![Atom::Not('b'),Atom::Base('c')]]));
    }

    #[test]
    fn dpll_basic_5() {
        assert_eq!(true,dpll(& mut vec![vec![Atom::Not('a'),Atom::Not('b')],vec![Atom::Not('a'),Atom::Base('c')],vec![Atom::Base('b'),Atom::Not('c')]]));
    }

    #[test]
    fn dpll_basic_6() {
        assert_eq!(true,dpll(& mut vec![vec![Atom::Base('a'),Atom::Not('b')],vec![Atom::Not('a'),Atom::Base('b')]]));
    }

    #[test]
    fn dpll_basic_7() {
        assert_eq!(true,dpll(& mut vec![vec![Atom::Not('a'),Atom::Base('b')],vec![Atom::Not('b'),Atom::Base('c')],vec![Atom::Not('c'),Atom::Base('a')]]));
    }

    #[test]
    fn dpll_basic_8() {
        assert_eq!(false,dpll(& mut vec![vec![Atom::Base('a')],vec![Atom::Not('a')]]));
    }

    #[test]
    fn dpll_basic_9() {
        assert_eq!(false,dpll(
            & mut vec![vec![Atom::Base('a'),Atom::Base('b'),Atom::Base('c')]
                      ,vec![Atom::Base('a'),Atom::Base('b'),Atom::Not('c')]
                      ,vec![Atom::Base('a'),Atom::Not('b'),Atom::Base('c')]
                      ,vec![Atom::Base('a'),Atom::Not('b'),Atom::Not('c')]
                      ,vec![Atom::Not('a'),Atom::Base('b'),Atom::Base('c')]
                      ,vec![Atom::Not('a'),Atom::Base('b'),Atom::Not('c')]
                      ,vec![Atom::Not('a'),Atom::Not('b'),Atom::Base('c')]
                      ,vec![Atom::Not('a'),Atom::Not('b'),Atom::Not('c')]
        ]));
    }
}