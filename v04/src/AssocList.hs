module AssocList(AssocList(..),doubleMap) where

data AssocList k a = 
     Nil
   | Cons(k,a,AssocList k a)
   deriving (Eq,Show)

instance Functor (AssocList k) where
   fmap = error "Unimplemented"

doubleMap :: (k -> a -> (k',a')) -> AssocList k a -> AssocList k' a'
doubleMap = error "Unimplemented"