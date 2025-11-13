#[cfg(test)]
mod block_tests {
    use crate::block::*;

    #[test]
    fn initial_basic_0() {
        let b0: Block = Block::initial(13);
        assert_eq!(b0.difficulty, 13);
        assert_eq!(b0.generation, 0);
        assert_eq!(b0.prev_hash, Hash::from([0; 32]));
        assert_eq!(b0.data, "");
        assert_eq!(b0.proof, None);
    }

    #[test]
    fn hash_string_for_proof_basic_0() {
        let b0: Block = Block {
            difficulty: 13,
            generation: 3,
            prev_hash: Hash::from([10; 32]),
            data: "Cool Data".to_string(),
            proof: Option::None,
        };
        assert_eq!(
            "0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a:3:13:Cool Data:4321",
            b0.hash_string_for_proof(4321)
        )
    }

    #[test]
    fn hash_for_proof_basic_0() {
        let b0: Block = Block {
            difficulty: 13,
            generation: 3,
            prev_hash: Hash::from([10; 32]),
            data: "Cool Data".to_string(),
            proof: Option::None,
        };
        assert_eq!(
            Hash::from([
                99, 66, 200, 198, 96, 57, 238, 158, 136, 127, 33, 80, 24, 122, 108, 205, 44, 40, 7,
                58, 131, 224, 179, 144, 96, 228, 207, 83, 74, 179, 142, 115
            ]),
            b0.hash_for_proof(4321)
        )
    }

    #[test]
    fn next_basic_0() {
        let b0: Block = Block {
            difficulty: 13,
            generation: 3,
            prev_hash: Hash::from([10; 32]),
            data: "Cool Data".to_string(),
            proof: Option::Some(102020),
        };
        let b1: Block = Block::next(&b0, "Cooler data".to_string());
        assert_eq!(b1.difficulty, 13);
        assert_eq!(b1.generation, 4);
        assert_eq!(b1.prev_hash, b0.hash());
        assert_eq!(b1.data, "Cooler data");
        assert_eq!(b1.proof, None);
    }

    #[test]
    fn hash_satisfies_difficulty_0() {
        assert!(Block::hash_satisfies_difficulty(
            8,
            Hash::from([
                99, 66, 200, 198, 96, 57, 238, 158, 136, 127, 33, 80, 24, 122, 108, 205, 44, 40, 7,
                58, 131, 224, 179, 144, 96, 228, 207, 83, 74, 179, 142, 0
            ])
        ))
    }

    #[test]
    fn hash_satisfies_difficulty_1() {
        assert!(Block::hash_satisfies_difficulty(
            9,
            Hash::from([
                99, 66, 200, 198, 96, 57, 238, 158, 136, 127, 33, 80, 24, 122, 108, 205, 44, 40, 7,
                58, 131, 224, 179, 144, 96, 228, 207, 83, 74, 179, 142, 0
            ])
        ))
    }

    #[test]
    fn hash_satisfies_difficulty_2() {
        assert!(!Block::hash_satisfies_difficulty(
            10,
            Hash::from([
                99, 66, 200, 198, 96, 57, 238, 158, 136, 127, 33, 80, 24, 122, 108, 205, 44, 40, 7,
                58, 131, 224, 179, 144, 96, 228, 207, 83, 74, 179, 142, 0
            ])
        ))
    }

    #[test]
    fn mine_basic_0() {
        let mut b0: Block = Block {
            difficulty: 13,
            generation: 3,
            prev_hash: Hash::from([10; 32]),
            data: "Cool Data".to_string(),
            proof: Option::Some(102020),
        };
        b0.mine(4);
        assert!(b0.is_valid());
    }

    #[test]
    // Test that mine_range with single worker finds a valid proof
    fn mine_range_single_worker() {
        let b0: Block = Block {
            difficulty: 8,
            generation: 0,
            prev_hash: Hash::from([0; 32]),
            data: "Test Block".to_string(),
            proof: None,
        };

        let range_end: u64 = 8 * (1 << b0.difficulty);
        let proof = b0.mine_range(1, 0, range_end, 10);

        assert!(b0.is_valid_for_proof(proof), "found proof should be valid");
    }

    #[test]
    // Test that mine_range with multiple workers finds a valid proof
    fn mine_range_multiple_workers() {
        let b0: Block = Block {
            difficulty: 10,
            generation: 1,
            prev_hash: Hash::from([5; 32]),
            data: "Multi-threaded test".to_string(),
            proof: None,
        };

        let range_end: u64 = 8 * (1 << b0.difficulty);
        let proof = b0.mine_range(4, 0, range_end, 20);

        assert!(
            b0.is_valid_for_proof(proof),
            "proof found by multiple workers should be valid"
        );
    }

    #[test]
    // Test that mine_range with many workers is faster than serial
    fn mine_range_performance() {
        use std::time::Instant;

        let b0: Block = Block {
            difficulty: 12,
            generation: 2,
            prev_hash: Hash::from([15; 32]),
            data: "Performance test".to_string(),
            proof: None,
        };

        let range_end: u64 = 8 * (1 << b0.difficulty);

        // Time single-threaded mining
        let start_single = Instant::now();
        let proof_single = b0.mine_range(1, 0, range_end, 50);
        let duration_single = start_single.elapsed();

        assert!(
            b0.is_valid_for_proof(proof_single),
            "single-threaded proof should be valid"
        );

        // Time multi-threaded mining
        let start_multi = Instant::now();
        let proof_multi = b0.mine_range(4, 0, range_end, 50);
        let duration_multi = start_multi.elapsed();

        assert!(
            b0.is_valid_for_proof(proof_multi),
            "multi-threaded proof should be valid"
        );

        // Multi-threaded should be faster (allowing some overhead)
        assert!(
            duration_multi < duration_single,
            "multi-threaded mining should be faster than single-threaded"
        );
    }

    #[test]
    // Test that mine_range works with different chunk sizes
    fn mine_range_various_chunks() {
        let b0: Block = Block {
            difficulty: 9,
            generation: 0,
            prev_hash: Hash::from([0; 32]),
            data: "Chunk test".to_string(),
            proof: None,
        };

        let range_end: u64 = 8 * (1 << b0.difficulty);

        // Test with 1 chunk
        let proof1 = b0.mine_range(2, 0, range_end, 1);
        assert!(
            b0.is_valid_for_proof(proof1),
            "proof with 1 chunk should be valid"
        );

        // Test with many chunks
        let proof2 = b0.mine_range(2, 0, range_end, 100);
        assert!(
            b0.is_valid_for_proof(proof2),
            "proof with 100 chunks should be valid"
        );

        // Test with chunks = range size
        let proof3 = b0.mine_range(2, 0, range_end, range_end);
        assert!(
            b0.is_valid_for_proof(proof3),
            "proof with chunks=range should be valid"
        );
    }

    #[test]
    // Test that mine method uses mine_range correctly
    fn mine_uses_mine_range() {
        let mut b0: Block = Block {
            difficulty: 11,
            generation: 5,
            prev_hash: Hash::from([7; 32]),
            data: "Testing mine method".to_string(),
            proof: None,
        };

        b0.mine(3);

        assert!(b0.proof.is_some(), "mine should set a proof");
        assert!(b0.is_valid(), "mined block should be valid");
    }

    #[test]
    // Test mine_for_proof returns valid proof
    fn mine_for_proof_valid() {
        let b0: Block = Block {
            difficulty: 10,
            generation: 0,
            prev_hash: Hash::from([0; 32]),
            data: "Direct proof test".to_string(),
            proof: None,
        };

        let proof = b0.mine_for_proof(2);

        assert!(
            b0.is_valid_for_proof(proof),
            "mine_for_proof should return valid proof"
        );
    }

    #[test]
    // Test that mine_range handles edge case of small range
    fn mine_range_small_range() {
        let b0: Block = Block {
            difficulty: 8,
            generation: 0,
            prev_hash: Hash::from([0; 32]),
            data: "Small range".to_string(),
            proof: None,
        };

        // Search only first 1000 values
        let proof = b0.mine_range(2, 0, 1000, 10);

        assert!(
            b0.is_valid_for_proof(proof),
            "should find proof in small range"
        );
        assert!(proof < 1000, "proof should be within specified range");
    }

    #[test]
    // Test that different workers can work on different blocks simultaneously
    fn mine_concurrent_blocks() {
        use std::thread;

        let b1: Block = Block {
            difficulty: 10,
            generation: 0,
            prev_hash: Hash::from([1; 32]),
            data: "Block 1".to_string(),
            proof: None,
        };

        let b2: Block = Block {
            difficulty: 10,
            generation: 0,
            prev_hash: Hash::from([2; 32]),
            data: "Block 2".to_string(),
            proof: None,
        };

        let b1_clone = b1.clone();
        let b2_clone = b2.clone();

        let handle1 = thread::spawn(move || {
            let range_end = 8 * (1 << b1_clone.difficulty);
            b1_clone.mine_range(2, 0, range_end, 20)
        });

        let handle2 = thread::spawn(move || {
            let range_end = 8 * (1 << b2_clone.difficulty);
            b2_clone.mine_range(2, 0, range_end, 20)
        });

        let proof1 = handle1.join().unwrap();
        let proof2 = handle2.join().unwrap();

        assert!(
            b1.is_valid_for_proof(proof1),
            "block 1 proof should be valid"
        );
        assert!(
            b2.is_valid_for_proof(proof2),
            "block 2 proof should be valid"
        );
    }

    #[test]
    // Test that MiningTask properly shares block via Arc
    fn mine_range_shares_block() {
        let b0: Block = Block {
            difficulty: 9,
            generation: 10,
            prev_hash: Hash::from([100; 32]),
            data: "Shared block test".to_string(),
            proof: None,
        };

        // Mine with multiple workers - each should have access to same block
        let range_end: u64 = 8 * (1 << b0.difficulty);
        let proof = b0.mine_range(5, 0, range_end, 25);

        assert!(
            b0.is_valid_for_proof(proof),
            "proof from shared block should be valid"
        );
    }
}
