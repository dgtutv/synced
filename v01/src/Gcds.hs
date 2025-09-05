module Gcds
  ( isDivisor,
    allDivisors,
    listIntersection,
    listGcd,
  )
where

import Prelude (Bool, Int, error, mod, (*), (+), (-), (/), (<), (==))

isDivisor :: Int -> Int -> Bool
isDivisor x y = x `mod` y == 0

allDivisors :: Int -> [Int]
allDivisors k = allDivisors' k k

allDivisors' :: Int -> Int -> [Int]
allDivisors' k 0 = []
allDivisors' k n =
  if n `isDivisor` k
    then n : allDivisors' k (n - 1)
    else allDivisors' k (n - 1)

listIntersection :: [Int] -> [Int] -> [Int] -- Take the numbers that are present in both lists and return only those
listIntersection a b =
  -- somehow iterate through a, if a' (the element of a currently) 'elem' b then return a
  if length a == 1
    then
      if head a `elem` b
        then a
        else []
    else
      listIntersection (tail a) b

listGcd :: Int -> Int -> Int
listGcd = error "Not Implemented"