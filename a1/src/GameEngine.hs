{-# LANGUAGE NoImplicitPrelude #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}

module GameEngine
    (   Score (..),
        toCandidateBasis,
        extractBases,
        basisToPuzzle,
        isWordCorrect,
        allAnswers,
        finalScore,
        cheat
    ) where

import Helpers
import Prelude hiding (foldl, foldr, init, map, length, filter, bind, (>>=), (>>), return, fail, null, concat, concatMap, (!!))

data Score = Zero | Bad | OK | Good | Great | Perfect
    deriving (Eq, Show)

type Dictionary = [String]
type Basis = [Char]
type Puzzle = (Char,[Char])

toCandidateBasis :: String -> Maybe Basis
toCandidateBasis = error "Unimplemented"

extractBases :: [String] -> [String]
extractBases = error "Unimplemented"

basisToPuzzle :: Basis -> Int -> Puzzle
basisToPuzzle = error "Unimplemented"

isWordCorrect :: Dictionary -> Puzzle -> String -> Bool
isWordCorrect = error "Unimplemented"

allAnswers :: Dictionary -> Puzzle -> [String]
allAnswers = error "Unimplemented"

finalScore :: Dictionary -> Puzzle -> [String] -> Score
finalScore = error "Unimplemented"

cheat :: (Puzzle -> String -> Bool) -> Int -> Puzzle -> [String]
cheat = error "Unimplemented"
