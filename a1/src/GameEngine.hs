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

import Data.List ((!!)) -- Remove and implement before submitting
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

-- Calculates all valid answers to the puzzle
-- Returns a list of strings that contain exactly one instance of every word, where isWordCorrect returns True
allAnswers :: Dictionary -> Puzzle -> [String]
allAnswers [] _ = [] -- All answers to an empty dictionary is just an empty string
allAnswers (x : xs) puzzle =
  if isWordCorrect (x : xs) puzzle x -- If first word is valid, include in answer, otherwise dont
    then x : allAnswers xs puzzle
    else allAnswers xs puzzle

finalScore :: Dictionary -> Puzzle -> [String] -> Score
finalScore dict puzzle ans
  | p == 0 = Zero
  | 0 < p && p < 0.25 = Bad
  | 0.25 <= p && p < 0.5 = OK
  | 0.5 <= p && p < 0.75 = Good
  | 0.75 <= p && p < 1 = Great
  | otherwise = Perfect
  where
    -- Iterate over user answers, calculate the amount correct
    -- Then, count all correct answers
    -- p is amount correct / all correct
    p = fromIntegral (numUserCorrect ans) / fromIntegral numAllCorrect -- Necessary to convert integer to fractional for comparison
    allCorrect = allAnswers dict puzzle
    numAllCorrect = length allCorrect
    numUserCorrect [] = 0
    numUserCorrect (x : xs) =
      if isWordCorrect dict puzzle x
        then 1 + numUserCorrect xs
        else numUserCorrect xs

-- valid solution predicate, numOfSolutions, puzzle, -> Answer

-- Generate all possible combinations from puzzle of size i (recursive, start at size of puzzle)
-- Filter all possible combinations using predicate
-- Cut off final list to numSol results
cheat :: (Puzzle -> String -> Bool) -> Int -> Puzzle -> [String]
cheat isValid numSol puzzle = take numSol (validGuesses 1) -- Limit to numSol solutions (why?)
  where
    letters = let (x, xs) = puzzle in x : xs -- Get letters in normal list form
    validGuesses i =
      if i > 7
        then []
        else filter (isValid puzzle) (guessesOfLen i letters) ++ validGuesses (i + 1) -- Only take valid guesses of curr num letters, and recursively call till we reach 7
    guessesOfLen 0 _ = [""] -- Empty string only possibility for 0 letters
    guessesOfLen _ [] = [] -- No letters, no guesses
    guessesOfLen i (x : xs) = map (x :) (guessesOfLen (i - 1) letters) ++ guessesOfLen i xs -- All combos of length i, add x. Then recursively add combos from xs
