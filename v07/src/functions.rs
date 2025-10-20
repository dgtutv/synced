//for n, if n is even, next number is n/2, else it is 3*n+1
pub fn next_hailstone(x: u32) -> u32 {
    if x % 2 == 0 {
        return x / 2;
    }
    3 * x + 1
}

pub fn hailstone_sequence(init: u32) -> Vec<u32> {
    let mut return_list = Vec::new();
    let mut curr = init;
    return_list.push(init);
    while curr > 1 {
        let next = next_hailstone(curr);
        return_list.push(next);
        curr = next;
    }
    return return_list;
}

pub fn find_elt<T: Eq>(v: Vec<T>, elt: T) -> Option<usize> {
    for (index, element) in v.iter().enumerate() {
        if (*element == elt) {
            return Some(index);
        }
    }
    return None;
}

pub fn all_indices<T: Eq>(v: Vec<T>, elt: T) -> Vec<usize> {
    let mut ret = Vec::new();
    for (index, element) in v.iter().enumerate() {
        if (*element == elt) {
            ret.push(index);
        }
    }
    ret
}
