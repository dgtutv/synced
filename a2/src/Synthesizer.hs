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
varExpressionsAtSize (Context lst) x
  | x /= 1 = []
  | x == 1 = fmap EVariable lst

notExpressionsAtSize :: (Int -> [Expression]) -> Int -> [Expression]
notExpressionsAtSize f 0 = []
notExpressionsAtSize f 1 = []
notExpressionsAtSize fn size = fmap ENot (fn (size - 1))

andExpressionsAtSize :: (Int -> [Expression]) -> Int -> [Expression]
andExpressionsAtSize _ 0 = []
andExpressionsAtSize f n = do
  (leftNums, rightNums) <- numberSplit (n - 1)
  leftExpressions <- f leftNums
  rightExpressions <- f rightNums
  return (EAnd (leftExpressions, rightExpressions))

orExpressionsAtSize :: (Int -> [Expression]) -> Int -> [Expression]
orExpressionsAtSize _ 0 = []
orExpressionsAtSize f n = do
  (leftNums, rightNums) <- numberSplit (n - 1)
  leftExpressions <- f leftNums
  rightExpressions <- f rightNums
  return (EOr (leftExpressions, rightExpressions))

expressionsAtSize :: Context -> Int -> [Expression]
expressionsAtSize _ 0 = []
expressionsAtSize context n = andExpressions ++ orExpressions ++ notExpressions ++ varExpressions ++ baseExpressions
  where
    andExpressions = andExpressionsAtSize (expressionsAtSize context) n
    orExpressions = orExpressionsAtSize (expressionsAtSize context) n
    notExpressions = notExpressionsAtSize (expressionsAtSize context) n
    varExpressions = varExpressionsAtSize context n
    baseExpressions = baseExpressionsAtSize n

expressionSatisfiesExamples :: Examples -> Expression -> Bool
expressionSatisfiesExamples (Examples examples) expression = all (\(assignment, expectedOutput) -> evaluate assignment expression == expectedOutput) examples

{-  Generate an expression that satisfies the examples. Check if there are
    examples at size 1, then at size 2, ... until either there are no
    expressions at size max or until an expression is found that satisfies the
    examples.

    HINT: Use a helper function
    HINT: The "find" function will be useful here
    HINT: The "evaluate" function will be useful here
-}

loop :: Context -> Examples -> Int -> Int -> Maybe Expression
loop context examples i max =
  let expressions = expressionsAtSize context i
      found = find (expressionSatisfiesExamples examples) expressions
   in if isJust found
        then found
        else
          if i < max
            then loop context examples (i + 1) max
            else Nothing

generator :: Context -> Examples -> Int -> Maybe Expression
generator context examples = loop context examples 1
