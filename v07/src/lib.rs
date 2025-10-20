mod functions;

#[cfg(test)]
mod next_hailstone_tests {
    use crate::functions::{next_hailstone};

    #[test]
    fn next_hailstone_basic_0() {
        assert_eq!(4,next_hailstone(8))
    }

    #[test]
    fn next_hailstone_basic_1() {
        assert_eq!(16,next_hailstone(5))
    }
}

#[cfg(test)]
mod hailstone_sequence_tests {
    use crate::functions::{hailstone_sequence};

    #[test]
    fn hailstone_sequence_basic_0() {
        assert_eq!(vec![3,10,5,16,8,4,2,1],hailstone_sequence(3));
    }

    #[test]
    fn hailstone_sequence_basic_1() {
        assert_eq!(vec![7,22,11,34,17,52,26,13,40,20,10,5,16,8,4,2,1],hailstone_sequence(7))
    }
}

#[cfg(test)]
mod find_elt_tests {
    use crate::functions::{find_elt};

    #[test]
    fn find_elt_basic_0() {
        assert_eq!(Option::Some(1),find_elt(vec![10,20,30], 20));
    }

    #[test]
    fn find_elt_basic_1() {
        assert_eq!(Option::None,find_elt(vec![10,20,30], 40));
    }
}

#[cfg(test)]
mod all_indices_tests {
    use crate::functions::{all_indices};

    #[test]
    fn all_indices_basic_0() {
        assert_eq!(vec![0,2],all_indices(vec![10,20,10], 10));
    }

    #[test]
    fn find_elt_basic_1() {
        assert_eq!(vec![1],all_indices(vec![10,20,10], 20));
    }
}