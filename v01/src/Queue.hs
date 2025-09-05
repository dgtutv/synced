module Queue
    ( empty,
      enqueue,
      dequeue
    ) where

import Prelude(error,Int,(++))

type Queue = ([Int],[Int])

empty :: Queue
empty = error "Not Implemented"

enqueue :: Queue -> Int -> Queue
enqueue = error "Not Implemented"

dequeue :: Queue -> (Int,Queue)
dequeue = error "Not Implemented"