//for n, if n is even, next number is n/2, else it is 3*n+1
pub fn next_hailstone(x: u32) -> u32 {
    if x % 2 == 0 {
        return x / 2;
    }
    3 * x + 1
}

pub fn hailstone_sequence(init: u32) -> Vec<u32> {
    unimplemented!();
}

pub fn find_elt<T: Eq>(v: Vec<T>, elt: T) -> Option<usize> {
    unimplemented!();
}

pub fn all_indices<T: Eq>(v: Vec<T>, elt: T) -> Vec<usize> {
    unimplemented!();
}
