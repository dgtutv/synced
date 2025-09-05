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

listIntersection :: [Int] -> [Int] -> [Int]
listIntersection = error "Not Implemented"

listGcd :: Int -> Int -> Int
listGcd = error "Not Implemented"