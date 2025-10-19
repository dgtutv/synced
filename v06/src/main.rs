fn main() {
    println!("Hello, world!");
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn check_two_plus_two() {
        assert_eq!(4,2+2)
    }
}