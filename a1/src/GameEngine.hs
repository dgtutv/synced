{-# LANGUAGE NoImplicitPrelude #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}

module GameEngine
  ( Score (..),
    toCandidateBasis,
    extractBases,
    basisToPuzzle,
    isWordCorrect,
    allAnswers,
    finalScore,
    cheat,
  )
where

import Data.List ((!!))
import Helpers
import Prelude hiding (bind, concat, concatMap, fail, filter, foldl, foldr, init, length, map, null, return, (!!), (>>), (>>=))

data Score = Zero | Bad | OK | Good | Great | Perfect
  deriving (Eq, Show)

type Dictionary = [String]

type Basis = [Char]

type Puzzle = (Char, [Char])

toCandidateBasis :: String -> Maybe Basis
toCandidateBasis s
  | length s /= 7 = Nothing
  | length s == 7 = Just $ removeDuplicates $ sort s
  where
    removeDuplicates [] = []
    removeDuplicates [x] = [x]
    removeDuplicates (x : xx : xs) =
      if x == xx
        then removeDuplicates (xs) -- Remove both instances of duplicates
        else x : removeDuplicates (xx : xs)

extractBases :: [String] -> [String]
extractBases dict = basisList
  where
    basisList = [b | Just b <- map toCandidateBasis filteredDict] -- Convert to concrete type
    filteredDict = filter (\curr -> length curr == 7) dict

basisToPuzzle :: Basis -> Int -> Puzzle
basisToPuzzle basis index = (currChar, filter (/= currChar) basis)
  where
    currChar = basis !! index

isWordCorrect :: Dictionary -> Puzzle -> String -> Bool
isWordCorrect = error "Unimplemented"

allAnswers :: Dictionary -> Puzzle -> [String]
allAnswers = error "Unimplemented"

finalScore :: Dictionary -> Puzzle -> [String] -> Score
finalScore = error "Unimplemented"

cheat :: (Puzzle -> String -> Bool) -> Int -> Puzzle -> [String]
cheat = error "Unimplemented"
