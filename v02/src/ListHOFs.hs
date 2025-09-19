{-# LANGUAGE NoImplicitPrelude #-}

module ListHOFs
    ( zip,
      alternatingMap,
      sumEvens,
      flatten
    ) where

import Prelude(Int(..),Maybe(..),filter,mod,(+),(.),(==),(++))
import GHC.Base

zip :: [a] -> [b] -> Maybe [(a,b)]
zip = 

alternatingMap :: (a -> b) -> (a -> b) -> [a] -> [b]
alternatingMap = error "Unimplemented"

sumEvens :: [Int] -> Int
sumEvens = error "Unimplemented"

flatten :: [[a]] -> [a]
flatten = error "Unimplemented"
