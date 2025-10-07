{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}

module Synthesizer
  ( numberSplit,
    baseExpressionsAtSize,
    varExpressionsAtSize,
    notExpressionsAtSize,
    andExpressionsAtSize,
    orExpressionsAtSize,
    expressionsAtSize,
    expressionSatisfiesExamples,
    generator,
  )
where

import Data.List
import Data.Maybe
import Language

boolCombos :: Int -> Int -> [(Int, Int)]
boolCombos 1 _ = []
boolCombos x y = (x - 1, y + 1) : boolCombos (x - 1) (y + 1)

numberSplit :: Int -> [(Int, Int)]
numberSplit 0 = []
numberSplit 1 = []
numberSplit x = boolCombos x 0

baseExpressionsAtSize :: Int -> [Expression]
baseExpressionsAtSize x
  | x /= 1 = []
  | x == 1 = [EBase True, EBase False]

varExpressionsAtSize :: Context -> Int -> [Expression]
varExpressionsAtSize = error "Unimplemented"

notExpressionsAtSize :: (Int -> [Expression]) -> Int -> [Expression]
notExpressionsAtSize = error "Unimplemented"

andExpressionsAtSize :: (Int -> [Expression]) -> Int -> [Expression]
andExpressionsAtSize f 0 = []
andExpressionsAtSize f n = do
  error "Unimplemented"

orExpressionsAtSize :: (Int -> [Expression]) -> Int -> [Expression]
orExpressionsAtSize f 0 = []
orExpressionsAtSize f n = do
  error "Unimplemented"

expressionsAtSize :: Context -> Int -> [Expression]
expressionsAtSize = error "Unimplemented"

expressionSatisfiesExamples :: Examples -> Expression -> Bool
expressionSatisfiesExamples = error "Unimplemented"

{-  Generate an expression that satisfies the examples. Check if there are
    examples at size 1, then at size 2, ... until either there are no
    expressions at size max or until an expression is found that satisfies the
    examples.

    HINT: Use a helper function
    HINT: The "find" function will be useful here
    HINT: The "evaluate" function will be useful here
-}
generator :: Context -> Examples -> Int -> Maybe Expression
generator = error "Unimplemented"
