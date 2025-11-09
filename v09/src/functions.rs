pub fn prefixes(s: &str) -> Vec<&str> {
    let mut ret: Vec<&str> = Vec::new();
    for i in 0..(s.len() + 1) {
        ret.push(&s[0..i]);
    }
    ret
}

pub fn return_if_satisfies_both<'a, 'b, T, F: Fn(&T) -> bool>(
    f: F,
    x: &'a T,
    y: &'b T,
) -> Option<(&'a T, &'b T)> {
    if f(x) && f(y) {
        Some((x, y))
    } else {
        None
    }
}

#[derive(Clone, PartialEq, Debug)]
pub enum List<T> {
    Nil,
    Cons(T, Box<List<T>>),
}

pub fn map<T, U, F: Fn(&T) -> U>(f: F, l: &List<T>) -> List<U> {
    match l {
        List::Nil => List::Nil,
        List::Cons(head, tail) => List::Cons(f(head), Box::new(map(f, tail))),
    }
}

pub fn concat<T: Copy>(l1: &List<T>, l2: &List<T>) -> List<T> {
    match l1 {
        List::Nil => l2.clone(),
        List::Cons(head, tail) => List::Cons(*head, Box::new(concat(tail, l2))),
    }
}
