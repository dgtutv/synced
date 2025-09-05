module Queue
  ( empty,
    enqueue,
    dequeue,
  )
where

import Prelude (Int, error, (++))

type Queue = ([Int], [Int]) -- ([popping list], [pushing list])

-- My version of reverse since it is not imported
reverseList :: [Int] -> [Int]
reverseList [] = []
reverseList (l : ls) = reverseList ls ++ [l]

-- When popping list is empty, pushing list is reversed and becomes popping list, pushing list set to empty
manageLists :: Queue -> Queue
manageLists ([], push) = (reverseList push, []) --  Case where lists get flipped
manageLists q = q -- Case where queue does not need flipping

empty :: Queue -- Create an empty queue
empty = ([], []) --  Generic case

enqueue :: Queue -> Int -> Queue -- Add an element to the queue
enqueue = error "Not Implemented"

dequeue :: Queue -> (Int, Queue)
dequeue = error "Not Implemented" -- Remove and return the next element to be dequeued