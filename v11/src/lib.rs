mod functions;

#[cfg(test)]
mod array_tests {
    use crate::functions::{Array};

    #[test]
    fn simple_array_get_set() {
        let a: Array<i32> = Array::new(5);
        a.set(2, 10);
        assert_eq!(*( unsafe { a.element_at(2) } ),10);
    }
}