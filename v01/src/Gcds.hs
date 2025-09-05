module Gcds
  ( isDivisor,
    allDivisors,
    listIntersection,
    listGcd,
  )
where

import Prelude (Bool, Int, error, mod, (*), (+), (-), (/), (<), (==))

isDivisor :: Int -> Int -> Bool
isDivisor x y = y `mod` x == 0

allDivisors :: Int -> [Int]
allDivisors k = allDivisors' k k

allDivisors' :: Int -> Int -> [Int]
allDivisors' k 0 = []
allDivisors' k n =
  if n `isDivisor` k
    then n : allDivisors' k (n - 1)
    else allDivisors' k (n - 1)

-- False = (1 == 0)
-- True = (1 == 1)
isElement :: Int -> [Int] -> Bool -- Since elem is not available
isElement _ [] = (1 == 0)
isElement x (y : ys) =
  if x == y
    then (1 == 1)
    else isElement x ys

listIntersection :: [Int] -> [Int] -> [Int] -- Take the numbers that are present in both lists and return only those
listIntersection [] _ = []
listIntersection (x : xs) ys =
  if x `isElement` ys
    then x : listIntersection xs ys -- Recurse through the tail, but adding head to return list
    else listIntersection xs ys -- Keep only any potentially remaining elements of list x

listGcd :: Int -> Int -> Int
listGcd a b =
  x
  where
    (x : xs) = listIntersection (allDivisors a) (allDivisors b)