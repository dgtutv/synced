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
alternatingMap = error "Unimplemented"

sumEvens :: [Int] -> Int
sumEvens = error "Unimplemented"

flatten :: [[a]] -> [a]
flatten = error "Unimplemented"
