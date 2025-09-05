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

enqueue :: Queue -> Int -> Queue -- Add an element to the queue, prepend to push list
enqueue (pop, push) e = (pop, e : push)

dequeue :: Queue -> (Int, Queue) -- Remove and return the next element to be dequeued
dequeue ([], []) = (0, empty) --  Case where queue is empty
dequeue ([], push) = dequeue (manageLists ([], push)) -- Popping list is empty, pushing list is not (hard case)
dequeue (p : ps, push) = (p, (ps, push)) --  Popping list is nonempty