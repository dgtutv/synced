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

isElement :: Int -> [Int] -> Bool
isElement _ [] = False
isElement x (y:ys) =
  if x==y
    then True
  else isElement x ys

listIntersection :: [Int] -> [Int] -> [Int] -- Take the numbers that are present in both lists and return only those
listIntersection [] _ = []
listIntersection (x:xs) ys = 

listGcd :: Int -> Int -> Int
listGcd = error "Not Implemented"