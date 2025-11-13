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
    loop {
        let f = match rec.recv() {
            Ok(v) => v, //Get value if sender open
            Err(_) => return x,
        };
        x = f(x);
    }
}

pub fn distributed_send_incr(
    fns: Vec<fn(i32) -> i32>,
) -> (Vec<JoinHandle<()>>, Receiver<fn(i32) -> i32>) {
    let (tx, rx) = mpsc::channel();
    let tx = Arc::new(Mutex::new(tx));

    let handles: Vec<JoinHandle<()>> = fns
        .into_iter()
        .map(|f| {
            let tx = Arc::clone(&tx);
            thread::spawn(move || {
                tx.lock().unwrap().send(f).unwrap();
            })
        })
        .collect();

    (handles, rx)
}
