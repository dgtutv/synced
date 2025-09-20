module TreeHOFs
  ( Tree (..),
    treeMap,
    treeFold,
    treeHeight,
    treeSum,
    treeSizer,
  )
where

data Tree a
  = Leaf
  | Node (Tree a, a, Tree a)
  deriving (Eq, Show)

treeMap :: (a -> b) -> Tree a -> Tree b
treeMap _ Leaf = Leaf
treeMap f (Node (ln, v, rn)) = Node (treeMap f ln, f v, treeMap f rn)

treeFold :: (b -> a -> b -> b) -> b -> Tree a -> b
treeFold f b Leaf = b

treeHeight :: Tree a -> Int
treeHeight = error "Unimplemented"

treeSum :: Tree Int -> Int
treeSum = error "Unimplemented"

treeSizer :: Tree a -> Tree (a, Int)
treeSizer = error "Unimplemented"
