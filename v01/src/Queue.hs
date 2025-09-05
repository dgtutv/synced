module Queue
  ( empty,
    enqueue,
    dequeue,
  )
where

import Prelude (Int, error, (++))

type Queue = ([Int], [Int]) -- ([popping list], [pushing list])

-- When popping list is empty, pushing list is reversed and becomes popping list, pushing list set to empty
manageLists :: Queue -> Queue
manageLists ([], push) = (reverse push, []) --  Case where lists get flipped
manageLists q = q -- Case where queue does not need flipping

empty :: Queue -- Create an empty queue
empty = ([], []) --  Generic case
-- empty a b = ([a], [b]) -- Incase user wants to specify elements as given in the example

enqueue :: Queue -> Int -> Queue -- Add an element to the queue
enqueue = error "Not Implemented"

dequeue :: Queue -> (Int, Queue)
dequeue = error "Not Implemented" -- Remove and return the next element to be dequeued