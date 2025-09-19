{-# LANGUAGE NoImplicitPrelude #-}

module ListHOFs
  ( zip,
    alternatingMap,
    sumEvens,
    flatten,
  )
where

import GHC.Base
import Prelude (Int (..), Maybe (..), filter, mod, (+), (++), (.), (==))

zip :: [a] -> [b] -> Maybe [(a, b)]
zip [] [] = Just []
zip [] _ = Nothing -- Base case, second list is shorter than first
zip _ [] = Nothing
zip (x : xs) (y : ys) =
  case zip xs ys of -- recursive call to zip
    Just zs -> Just ((x, y) : zs) -- Recursive call success, append zipped heads to recursed (already zipped) tail
    Nothing -> Nothing

alternatingMap :: (a -> b) -> (a -> b) -> [a] -> [b]
alternatingMap f1 f2 [] = []
alternatingMap f1 f2 (x : xs) = f1 x : alternatingMap f2 f1 xs

even :: [Int] -> [Int]
even = filter a
  where
    a x = x `mod` 2 == 0

sumEvens :: [Int] -> Int
sumEvens xs = sum (filter even xs)
  where
    even x = x `mod` 2 == 0
    sum [] = 0
    sum (y : ys) = y + sum ys

flatten :: [[a]] -> [a]
flatten = error "Unimplemented"
