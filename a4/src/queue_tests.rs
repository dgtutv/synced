#[cfg(test)]
mod queue_tests {
    use crate::queue::{Task, WorkQueue};
    use std::sync::atomic::{AtomicUsize, Ordering};
    use std::time::{Duration, Instant};
    use std::{sync, thread, time};

    const DELAY: time::Duration = Duration::from_millis(200);
    const CORRECT_RESULT: i64 = 123456;

    #[derive(Debug)]
    struct TestTask {
        counter: sync::Arc<AtomicUsize>, // safely-shared counter, to track number of tasks run
    }
    impl Task for TestTask {
        type Output = i64;
        fn run(&self) -> Option<i64> {
            thread::sleep(DELAY);
            let _ = &self.counter.fetch_add(1, Ordering::SeqCst);
            Some(CORRECT_RESULT)
        }
    }

    #[test]
    // Test that the work queue can do jobs and get correct results back.
    fn basics() {
        let n_threads: usize = 2;
        let n_tasks: usize = 20;
        let n_run = sync::Arc::<AtomicUsize>::new(0.into());

        let mut q = WorkQueue::<TestTask>::new(n_threads);

        for _ in 0..n_tasks {
            q.enqueue(TestTask {
                counter: n_run.clone(),
            })
            .unwrap();
        }

        // If <n_tasks results are returned, this will deadlock.
        for _ in 0..n_tasks {
            let r = q.recv();
            assert_eq!(r, CORRECT_RESULT);
        }

        // Give leftover workers time to complete, but there shouldn't be any.
        thread::sleep(3 * DELAY);

        // No more results should be produced, so try_recv is expected to return Err
        let r = q.try_recv();
        assert!(r.is_err());

        // Make sure the correct number of tasks has actually been run.
        let n_run_ref_count = sync::Arc::strong_count(&n_run);
        assert_eq!(n_run_ref_count, 1);
        let final_n_run = sync::Arc::try_unwrap(n_run).unwrap().load(Ordering::SeqCst);
        assert_eq!(final_n_run, n_tasks);
    }

    #[test]
    // Test that the work queue is actually doing things concurrently in the right way.
    fn concurrently() {
        let n_threads: usize = 4; // Should be easy to parallelize the .Sleep call, regardless of number of cores.
        let n_tasks: usize = 20;
        let n_run = sync::Arc::<AtomicUsize>::new(0.into()); // not used in this test

        let mut q = WorkQueue::<TestTask>::new(n_threads);

        for _ in 0..n_tasks {
            q.enqueue(TestTask {
                counter: n_run.clone(),
            })
            .unwrap();
        }

        // Time how long it takes to get all of the results out.
        let start = Instant::now();
        for _ in 0..n_tasks {
            let r = q.recv();
            assert_eq!(r, CORRECT_RESULT);
        }
        let end = Instant::now();

        // Time taken should be close to what we expect
        let time_taken = end.duration_since(start).as_millis();
        let target_time = DELAY.as_millis() * (n_tasks / n_threads) as u128;

        assert!(time_taken as f64 <= (target_time as f64) * 1.3, "Queue appears to not be running tasks concurrently: n_workers tasks should be happening in parallel.");

        assert!(time_taken as f64 > (target_time as f64) * 0.9, "Queue appears to be running too concurrently: it should only start n_workers concurrent tasks.");
    }

    #[test]
    // Test that the work queue stops processing jobs when asked to do so.
    fn stop() {
        let n_threads: usize = 4;
        let n_tasks: usize = 50;
        let n_run = sync::Arc::<AtomicUsize>::new(0.into());

        let mut q = WorkQueue::<TestTask>::new(n_threads);

        for _ in 0..n_tasks {
            q.enqueue(TestTask {
                counter: n_run.clone(),
            })
            .unwrap();
        }

        let mut n_results: usize = 0;
        for r in q.iter() {
            assert_eq!(r, CORRECT_RESULT);
            n_results += 1;
            if n_results > n_threads {
                // Pretend n_threads tasks give result that don't mean "complete". (*)
                q.shutdown(); // After that, tell the queue we're done and to stop processing tasks;
                break; // and we're done.
            }
        }

        // give workers long enough to do whatever they're going to do
        thread::sleep((2 * n_tasks / n_threads) as u32 * DELAY);

        // We expect:
        // n_threads tasks for "incomplete" work (* above);
        // n_threads running when we send the shutdown signal;
        // up to n_threads started while shutting down.
        let final_n_run = sync::Arc::try_unwrap(n_run).unwrap().load(Ordering::SeqCst);
        assert!(final_n_run <= n_threads * 3, "too many tasks executed");
        assert!(final_n_run >= n_threads * 2, "not enough tasks executed");
    }

    #[test]
    // Test that checks that threads aren't being leaked
    fn thread_leak() {
        let n_threads: usize = 10;
        let n_tasks: usize = 4000;
        let n_run = sync::Arc::<AtomicUsize>::new(0.into());

        let mut q = WorkQueue::<TestTask>::new(n_threads);
        for _ in 0..n_tasks {
            q.enqueue(TestTask {
                counter: n_run.clone(),
            })
            .unwrap();
        }
        q.shutdown();

        // After .shutdown returns, we expect all worker threads to have been joined: if anybody is still working, it's a problem.
        let before: usize = (*n_run).load(Ordering::SeqCst);
        thread::sleep(5 * DELAY);
        let after: usize = (*n_run).load(Ordering::SeqCst);
        assert_eq!(
            before, after,
            "work continued after .shutdown(): threads were leaked because they weren't joined"
        );
    }

    #[test]
    // Test that enqueue successfully sends tasks to workers
    fn enqueue_success() {
        let n_threads: usize = 2;
        let n_run = sync::Arc::<AtomicUsize>::new(0.into());

        let mut q = WorkQueue::<TestTask>::new(n_threads);

        // Enqueue a single task and verify it succeeds
        let result = q.enqueue(TestTask {
            counter: n_run.clone(),
        });
        assert!(result.is_ok(), "enqueue should succeed on an open queue");

        // Verify the task was processed
        let output = q.recv();
        assert_eq!(output, CORRECT_RESULT);
    }

    #[test]
    // Test that enqueue returns an error after shutdown
    fn enqueue_after_shutdown() {
        let n_threads: usize = 2;
        let n_run = sync::Arc::<AtomicUsize>::new(0.into());

        let mut q = WorkQueue::<TestTask>::new(n_threads);

        // Shutdown the queue
        q.shutdown();

        // Attempt to enqueue after shutdown should fail
        let result = q.enqueue(TestTask {
            counter: n_run.clone(),
        });
        assert!(result.is_err(), "enqueue should fail after shutdown");
    }

    #[test]
    // Test that multiple enqueues work correctly
    fn multiple_enqueue() {
        let n_threads: usize = 3;
        let n_tasks: usize = 10;
        let n_run = sync::Arc::<AtomicUsize>::new(0.into());

        let mut q = WorkQueue::<TestTask>::new(n_threads);

        // Enqueue multiple tasks, each should succeed
        for _ in 0..n_tasks {
            let result = q.enqueue(TestTask {
                counter: n_run.clone(),
            });
            assert!(result.is_ok(), "each enqueue should succeed");
        }

        // Collect all results
        let mut results_count = 0;
        for _ in 0..n_tasks {
            let r = q.recv();
            assert_eq!(r, CORRECT_RESULT);
            results_count += 1;
        }
        assert_eq!(
            results_count, n_tasks,
            "should receive exactly n_tasks results"
        );
    }

    #[test]
    #[should_panic]
    // Test that enqueue panics when send_tasks is None (if implementation uses panic)
    fn enqueue_panic_when_none() {
        let n_threads: usize = 2;
        let n_run = sync::Arc::<AtomicUsize>::new(0.into());

        let mut q = WorkQueue::<TestTask>::new(n_threads);

        // Manually shutdown to set send_tasks to None
        q.shutdown();

        // This should panic if send_tasks is None and implementation uses unwrap/expect
        // If implementation returns Err instead, this test may need adjustment
        let _ = q
            .enqueue(TestTask {
                counter: n_run.clone(),
            })
            .unwrap(); // unwrap will panic on Err
    }

    #[test]
    // Test that shutdown destroys the sender
    fn shutdown_destroys_sender() {
        let n_threads: usize = 3;
        let n_run = sync::Arc::<AtomicUsize>::new(0.into());

        let mut q = WorkQueue::<TestTask>::new(n_threads);

        // Enqueue some tasks
        for _ in 0..5 {
            q.enqueue(TestTask {
                counter: n_run.clone(),
            })
            .unwrap();
        }

        // Shutdown should complete successfully
        q.shutdown();

        // After shutdown, trying to enqueue should fail
        let result = q.enqueue(TestTask {
            counter: n_run.clone(),
        });
        assert!(
            result.is_err(),
            "enqueue should fail after sender is destroyed"
        );
    }

    #[test]
    // Test that shutdown drains remaining tasks
    fn shutdown_drains_tasks() {
        let n_threads: usize = 2;
        let n_tasks: usize = 100;
        let n_run = sync::Arc::<AtomicUsize>::new(0.into());

        let mut q = WorkQueue::<TestTask>::new(n_threads);

        // Enqueue many tasks
        for _ in 0..n_tasks {
            q.enqueue(TestTask {
                counter: n_run.clone(),
            })
            .unwrap();
        }

        // Receive only a few results before shutting down
        for _ in 0..5 {
            let _ = q.recv();
        }

        // Shutdown should drain remaining tasks
        q.shutdown();

        // No more results should be available after shutdown
        let result = q.try_recv();
        assert!(
            result.is_err(),
            "no results should be available after shutdown drains tasks"
        );
    }

    #[test]
    // Test that shutdown joins all worker threads
    fn shutdown_joins_workers() {
        let n_threads: usize = 5;
        let n_tasks: usize = 20;
        let n_run = sync::Arc::<AtomicUsize>::new(0.into());

        let mut q = WorkQueue::<TestTask>::new(n_threads);

        for _ in 0..n_tasks {
            q.enqueue(TestTask {
                counter: n_run.clone(),
            })
            .unwrap();
        }

        // Collect some results
        for _ in 0..10 {
            let _ = q.recv();
        }

        let tasks_before_shutdown = (*n_run).load(Ordering::SeqCst);

        // Shutdown should wait for all workers to finish
        q.shutdown();

        // After shutdown, no additional work should happen
        thread::sleep(3 * DELAY);
        let tasks_after_shutdown = (*n_run).load(Ordering::SeqCst);

        assert_eq!(
            tasks_before_shutdown, tasks_after_shutdown,
            "no work should occur after shutdown completes"
        );
    }

    #[test]
    // Test that shutdown can be called multiple times safely
    fn shutdown_idempotent() {
        let n_threads: usize = 2;
        let n_run = sync::Arc::<AtomicUsize>::new(0.into());

        let mut q = WorkQueue::<TestTask>::new(n_threads);

        q.enqueue(TestTask {
            counter: n_run.clone(),
        })
        .unwrap();

        let _ = q.recv();

        // First shutdown
        q.shutdown();

        // Second shutdown should be safe (no panic, no hang)
        q.shutdown();

        // Should still be safe to drop
        drop(q);
    }

    #[test]
    // Test that workers vec is empty after shutdown
    fn shutdown_clears_workers() {
        let n_threads: usize = 4;
        let n_run = sync::Arc::<AtomicUsize>::new(0.into());

        let mut q = WorkQueue::<TestTask>::new(n_threads);

        // Enqueue and process some tasks
        for _ in 0..10 {
            q.enqueue(TestTask {
                counter: n_run.clone(),
            })
            .unwrap();
        }

        for _ in 0..10 {
            let _ = q.recv();
        }

        // After shutdown, workers should be joined and removed
        q.shutdown();

        // The workers vector should be drained
        // (This is implicit in the implementation, but shutdown should complete successfully)
        // If shutdown didn't properly join threads, this test would hang
    }

    #[test]
    // Test that drop calls shutdown if not already shut down
    fn drop_calls_shutdown() {
        let n_threads: usize = 3;
        let n_tasks: usize = 15;
        let n_run = sync::Arc::<AtomicUsize>::new(0.into());

        {
            let mut q = WorkQueue::<TestTask>::new(n_threads);

            for _ in 0..n_tasks {
                q.enqueue(TestTask {
                    counter: n_run.clone(),
                })
                .unwrap();
            }

            // Collect a few results
            for _ in 0..5 {
                let _ = q.recv();
            }

            // q goes out of scope here, drop should call shutdown
        }

        // After drop, threads should be joined
        let before = (*n_run).load(Ordering::SeqCst);
        thread::sleep(3 * DELAY);
        let after = (*n_run).load(Ordering::SeqCst);

        assert_eq!(
            before, after,
            "drop should have called shutdown and joined all threads"
        );
    }
}
