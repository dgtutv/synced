module AssocList (AssocList (..), doubleMap) where

data AssocList k a
  = Nil
  | Cons (k, a, AssocList k a) -- Key, value (could be datatypes or values), List of values
  -- (x:xs, where x = (k, a))
  deriving (Eq, Show)

-- Transform data of AssocList
instance Functor (AssocList k) where
  fmap fn Nil = Nil
  fmap fn (Cons (currK, currV, xs)) = Cons (currK, fn currV, fmap fn xs)

-- Transform data and keys of AssocList
doubleMap :: (k -> a -> (k', a')) -> AssocList k a -> AssocList k' a'
doubleMap fn Nil = Nil
doubleMap fn (Cons (currK, currV, xs)) = Cons (newK, newV, doubleMap fn xs)
  where
    (newK, newV) = fn currK currV