module QueueTests where

import TestingFramework
import Queue

test_empty :: [(String,IO TestResult)]
test_empty = do
    [("emptyBasic",testEqual ([],[]) empty)]

test_dequeueEmpty :: [(String,IO TestResult)]
test_dequeueEmpty =
    [("dequeueEmptyBasic",testEqual (0,([],[])) (dequeue empty))]

test_enqueueDequeue :: [(String,IO TestResult)]
test_enqueueDequeue =
    [("enqueueDequeueBasic0",testEqual 1 (nthQueueElement 0 (enqueueList [1,2,3,4] empty)))
    ,("enqueueDequeueBasic1",testEqual 3 (nthQueueElement 2 (enqueueList [1,2,3,4] empty)))
    ,("enqueueDequeueBasic2",testEqual 0 (nthQueueElement 4 (enqueueList [1,2,3,4] empty)))
    ,("enqueueDequeueBasic3",testEqual 4 (nthQueueElement 3 (enqueueList [1,2,3,4] empty)))
    ]
    where
        enqueueList []  q = q
        enqueueList (h:t) q = enqueueList t (enqueue q h)
        nthQueueElement 0 q = fst (dequeue q)
        nthQueueElement n q = nthQueueElement (n-1) (snd (dequeue q))

test_multiQAndD :: [(String,IO TestResult)]
test_multiQAndD =
    [("multi1",testEqual 4 (fst $ dequeue (snd $ dequeue (enqueue (snd $ dequeue (enqueue (enqueue empty 1) 2)) 4))))
    ,("multi2",testEqual 2 (fst $ dequeue (enqueue (snd $ dequeue (enqueue (enqueue empty 1) 2)) 4)))]
    where
        enqueueList []  q = q
        enqueueList (h:t) q = enqueueList t (enqueue q h)
        nthQueueElement 0 q = fst (dequeue q)
        nthQueueElement n q = nthQueueElement (n-1) (snd (dequeue q))

allTests :: TestSuite
allTests = test_empty ++ test_dequeueEmpty ++ test_enqueueDequeue ++ test_multiQAndD
