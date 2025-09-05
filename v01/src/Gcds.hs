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
allDivisors 1 = [1]
allDivisors k
  | 2 `isDivisor` k = k : allDivisors (k / 2)
  | 3 `isDivisor` k = k : allDivisors (k / 3)

listIntersection :: [Int] -> [Int] -> [Int]
listIntersection = error "Not Implemented"

listGcd :: Int -> Int -> Int
listGcd = error "Not Implemented"