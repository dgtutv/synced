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
        then removeDuplicates (filter (/= x) xs) -- Remove both instances of duplicates
        else x : removeDuplicates (xx : xs)

count :: (Eq a) => a -> [a] -> Int
count x xs = length (filter (== x) xs)

extractBases :: [String] -> [String]
extractBases dict = uniqueBases
  where
    basisList = [b | Just b <- map toCandidateBasis filteredDict] -- Convert to concrete type
    filteredDict = filter (\curr -> length curr == 7) dict -- Filter only 7 length bases
    uniqueBases = filter (\b -> count b basisList == 1) basisList -- Remove duplicates (may be re-introduced by scrambled bases containing same letters)

basisToPuzzle :: Basis -> Int -> Puzzle
basisToPuzzle basis index = (currChar, filter (/= currChar) basis)
  where
    currChar = basis !! index

-- Returns true if provided string in dictionary && provided string only contains letters in the puzzle and contains at least one instance of char in puzzle
isWordCorrect :: Dictionary -> Puzzle -> String -> Bool
isWordCorrect dict puzzle str = stringInPuzzle && exclusiveLetters str puzzle && containsChar puzzle
  where
    stringInPuzzle = count str dict > 0
    exclusiveLetters [] _ = True
    exclusiveLetters (c : cs) (x, xs) = count c (x : xs) > 0 && exclusiveLetters cs (x, xs) -- Test the string against the puzzle, not the other way around
    containsChar (x, xs) = count x str > 0

allAnswers :: Dictionary -> Puzzle -> [String]
allAnswers = error "Unimplemented"

finalScore :: Dictionary -> Puzzle -> [String] -> Score
finalScore = error "Unimplemented"

cheat :: (Puzzle -> String -> Bool) -> Int -> Puzzle -> [String]
cheat = error "Unimplemented"
