module TreeHOFs
    ( Tree(..),
      treeMap,
      treeFold,
      treeHeight,
      treeSum,
      treeSizer
    ) where

data Tree a =
    Leaf
  | Node (Tree a,a,Tree a)
  deriving (Eq,Show)

treeMap :: (a -> b) -> Tree a -> Tree b
treeMap = error "Unimplemented"

treeFold :: (b -> a -> b -> b) -> b -> Tree a -> b
treeFold = error "Unimplemented"

treeHeight :: Tree a -> Int
treeHeight = error "Unimplemented"

treeSum :: Tree Int -> Int
treeSum = error "Unimplemented"

treeSizer :: Tree a -> Tree (a,Int)
treeSizer = error "Unimplemented"
