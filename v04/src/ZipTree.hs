{-# LANGUAGE InstanceSigs #-}

module ZipTree (Tree (..)) where

data Tree a
  = Leaf
  | Node (Tree a, a, Tree a)
  deriving (Eq, Show)

instance Functor Tree where
  fmap f Leaf = Leaf
  fmap f (Node (l, v, r)) = Node (fmap f l, f v, fmap f r)

instance Applicative Tree where
  pure x = Node (pure x, x, pure x)
  (<*>) :: Tree (a -> b) -> Tree a -> Tree b
  _ <*> Leaf = Leaf
  Leaf <*> _ = Leaf
  (Node (x1, fx, x2)) <*> (Node (y1, fy, y2)) = Node (x1 <*> y1, fx fy, x2 <*> y2)