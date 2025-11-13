mod functions;

use std::{sync::{Arc, Mutex}, thread};

#[cfg(test)]
mod shared_state_incr_tests {
    use std::{sync::{Arc, Mutex}, thread};

    use crate::functions::{shared_state_incr};

    #[test]
    fn shared_state_incr_basic_0() {
        let v:i32 = 0;
        let x = Arc::new(Mutex::new(v));
        let x1 = x.clone();
        let x2 = x.clone();
        let x3 = x.clone();
        thread::spawn(move || {
            shared_state_incr(x1);
        }).join().unwrap();
        thread::spawn(move || {
            shared_state_incr(x2);
        }).join().unwrap();
        thread::spawn(move || {
            shared_state_incr(x3);
        }).join().unwrap();
        let res = *(x.lock().unwrap());
        assert_eq!(3,res)
    }
}

#[cfg(test)]
mod distributed_receive_incr {
    use std::{sync::mpsc::{self, Sender, Receiver}, thread};

    use crate::functions::{distributed_receive_incr};

    #[test]
    fn distributed_receive_incr_basic_0() {
        let (producer0,consumer): (Sender<fn(i32) -> i32>,Receiver<fn(i32) -> i32>) = mpsc::channel();
        let producer1 = producer0.clone();
        let thread0 = thread::spawn(move || {
            let f = (|x| {x+1});
            producer0.send(f);
        });
        let thread1 = thread::spawn(move || {
            let f = (|x| {x+3});
            producer1.send(f);
        });
        thread0.join();
        thread1.join();
        assert_eq!(4,distributed_receive_incr(consumer, 0));
    }
}

#[cfg(test)]
mod distributed_send_incr {
    use std::{sync::mpsc::{self, Sender, Receiver}, thread};

    use crate::functions::{distributed_send_incr};
    //not provided
}