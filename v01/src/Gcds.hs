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
allDivisors' k n
  | n `isDivisor` k = n : allDivisors' k (n - 1)
  | n `isDivisor` k == (1 == 0) = allDivisors' k (n - 1) -- since False, not, and other are not available

listIntersection :: [Int] -> [Int] -> [Int]
listIntersection = error "Not Implemented"

listGcd :: Int -> Int -> Int
listGcd = error "Not Implemented"