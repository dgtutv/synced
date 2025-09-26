module SwitchableStack
  ( State,
    empty,
    push,
    pop,
    setInactive,
    setActive,
    mapState,
    popWhere,
  )
where

import Data.List (elem, nub)

data State a = State {active :: Bool, stack :: [a]}

{- This should create an empty state of your stack.
   By default, your stack should be active. -}
empty :: State a
empty = State {active = True, stack = []}

{- This should push a new element onto your stack.
   In this stack, you cannot have two of the element on the stack.
   If the element already exists on the stack, do not edit the state. -}
push :: (Eq a) => State a -> a -> State a
push (State {active = act, stack = st}) a
  | a `elem` st = State {active = act, stack = st}
  | act = State {active = act, stack = a : st} -- Add duplicate protection
  | otherwise = State {active = act, stack = st}

{- This should pop the most recently added element off the stack.
   If there are no elements on the stack, return Nothing and an
   unedited version of the stack.
   If the stack is not active, return Nothing and an unedited version
   of the stack. -}
pop :: State a -> (Maybe a, State a)
pop = error "Unimplemented"

{- This should switch the stack to the "inactive" state.
When a stack is inactive, elements can be pushed on it, but they
cannot be popped off it. -}
setInactive :: State a -> State a
setInactive = error "Unimplemented"

{- This should switch the stack to the "active" state.
When a stack is active, elements can be pushed on it, and they
can be popped off it. -}
setActive :: State a -> State a
setActive = error "Unimplemented"

{- This edits elements on the stack according to the provided function.
   However, this edit may cause duplicates to be added. After mapping the state,
   be sure to remove duplicate elements. -}
mapState :: (Eq b) => (a -> b) -> State a -> State b
mapState = error "Unimplemented"

{- This pops all elements that satisfy a given predicate off the stack.
   The remaining elements on the stack are those that do not satisfy
   the provided predicate, in the original order.
   Do not pop any elements from the stack if the stack is inactive. -}
popWhere :: (a -> Bool) -> State a -> ([a], State a)
popWhere = error "Unimplemented"
