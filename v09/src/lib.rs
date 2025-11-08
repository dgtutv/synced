mod functions;

#[cfg(test)]
mod prefixes_tests {
    use crate::functions::{prefixes};

    #[test]
    fn prefixes_basic_0() {
        assert_eq!(vec!["","H","He","Hel","Hell","Hello"],prefixes("Hello"))
    }

    #[test]
    fn prefixes_basic_1() {
        assert_eq!(vec!["","W","Wo","Wor","Worl","World","World!"],prefixes("World!"))
    }
}

#[cfg(test)]
mod return_if_satisfies_both_tests {
    use crate::functions::{return_if_satisfies_both};

    #[test]
    fn return_if_satisfies_both_basic_0() {
        let x = vec![1,2,3];
        let y = vec![4,5,6];
        assert_eq!(Option::Some((&x,&y)),return_if_satisfies_both(|val| true,&x,&y));
    }

    #[test]
    fn return_if_satisfies_both_basic_1() {
        let x = vec![1,2,3];
        let y = vec![4,5,6];
        assert_eq!(Option::None,return_if_satisfies_both(|val| false,&x,&y));
    }

    #[test]
    fn return_if_satisfies_both_basic_2() {
        let x = vec![1];
        let y = vec![4,5,6];
        assert_eq!(Option::None,return_if_satisfies_both(|val| val.len() == 1,&x,&y));
    }
}

#[cfg(test)]
mod map_tests {
    use crate::functions::{List,map};

    #[test]
    fn map_basic_0() {
        let x = 
            List::Cons(0,
                Box::new(List::Cons(1,
                Box::new(List::Cons(2,
                Box::new(List::Cons(3,
                Box::new(List::Nil))))))));
        let y = 
            List::Cons(1,
                Box::new(List::Cons(2,
                Box::new(List::Cons(3,
                Box::new(List::Cons(4,
                Box::new(List::Nil))))))));
        assert_eq!(y,map(|val| val+1,&x));
    }

    #[test]
    fn map_basic_1() {
        let x = 
            List::Cons(0,
                Box::new(List::Cons(1,
                Box::new(List::Cons(2,
                Box::new(List::Cons(3,
                Box::new(List::Nil))))))));
        let y = 
            List::Cons("0".to_string(),
                Box::new(List::Cons("1".to_string(),
                Box::new(List::Cons("2".to_string(),
                Box::new(List::Cons("3".to_string(),
                Box::new(List::Nil))))))));
        assert_eq!(y,map(|val| format!("{:?}",val),&x));
    }
}

#[cfg(test)]
mod concat_tests {
    use crate::functions::{List,concat};

    #[test]
    fn concat_basic_0() {
        let x1 = 
            List::Cons(0,
                Box::new(List::Cons(1,
                Box::new(List::Cons(2,
                Box::new(List::Cons(3,
                Box::new(List::Nil))))))));
        let x2 = 
            List::Cons(4,
                Box::new(List::Cons(5,
                Box::new(List::Cons(6,
                Box::new(List::Nil))))));
        let y = 
            List::Cons(0,
                Box::new(List::Cons(1,
                Box::new(List::Cons(2,
                Box::new(List::Cons(3,
                Box::new(List::Cons(4,
                Box::new(List::Cons(5,
                Box::new(List::Cons(6,
                Box::new(List::Nil))))))))))))));
        assert_eq!(y,concat(&x1,&x2));
    }

    #[test]
    fn concat_basic_1() {
        let x1 = 
            List::Cons('0',
                Box::new(List::Cons('1',
                Box::new(List::Nil))));
        let x2 = 
            List::Cons('2',
                Box::new(List::Cons('3',
                Box::new(List::Cons('4',
                Box::new(List::Cons('5',
                Box::new(List::Nil))))))));
        let y = 
            List::Cons('0',
                Box::new(List::Cons('1',
                Box::new(List::Cons('2',
                Box::new(List::Cons('3',
                Box::new(List::Cons('4',
                Box::new(List::Cons('5',
                Box::new(List::Nil))))))))))));
        assert_eq!(y,concat(&x1,&x2));
    }
}