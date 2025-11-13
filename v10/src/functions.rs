use std::{
    sync::{
        mpsc::{self, Receiver, Sender},
        Arc, Mutex,
    },
    thread::{self, JoinHandle},
};

pub fn shared_state_incr(x: Arc<Mutex<i32>>) {
    *x.lock().unwrap() += 1
}

pub fn distributed_receive_incr(rec: Receiver<fn(i32) -> i32>, mut x: i32) -> i32 {
    unimplemented!();
}

pub fn distributed_send_incr(
    fns: Vec<fn(i32) -> i32>,
) -> (Vec<JoinHandle<()>>, Receiver<fn(i32) -> i32>) {
    unimplemented!();
}
