module GameEngineTests (
  allTests
) where

import TestingFramework
import Data.List
import GameEngine

test_toCandidateBasis :: TestSuite
test_toCandidateBasis =
    [ ("test_toCandidateBasisBasic0",testEqual (Just "abcdefg") (toCandidateBasis "gabcdef"))
    , ("test_toCandidateBasisBasic1",testEqual Nothing (toCandidateBasis "abcdefgh"))
    , ("test_toCandidateBasisBasic2",testEqual Nothing (toCandidateBasis "abcdef"))
    ]

test_extractBases :: TestSuite
test_extractBases =
    [ ("test_extractBasesBasic0", testEqual ["abcdefg"] (extractBases ["abcdefg"]))
    , ("test_extractBasesBasic1", testEqual [] (extractBases ["abcdefg","gabcdef"]))
    , ("test_extractBasesBasic2", testEqual ["abcdefg"] (extractBases ["bcdefg","gabcdef"]))
    ]

test_basisToPuzzle :: TestSuite
test_basisToPuzzle =
    let (c0,rest0) = basisToPuzzle "abcdefg" 0 in
    let t0 = testEqual ('a',"bcdefg") (c0,sort rest0) in
    let (c1,rest1) = basisToPuzzle "abcdefg" 1 in
    let t1 = testEqual ('b',"acdefg") (c1,sort rest1) in
    let (c2,rest2) = basisToPuzzle "abcdefg" 2 in
    [("test_basisToPuzzleBasic0",t0),("test_basisToPuzzleBasic1",t1)]

test_isWordCorrect :: TestSuite
test_isWordCorrect =
  [ ("test_isWordCorrectBasic0",testEqual True (isWordCorrect ["abc"] ('a',"bcdefg") "abc"))
  , ("test_isWordCorrectBasic1",testEqual False (isWordCorrect [] ('a',"bcdefg") "abc"))
  , ("test_isWordCorrectBasic2",testEqual False (isWordCorrect ["bc"] ('a',"bcdefg") "bc"))
  , ("test_isWordCorrectBasic3",testEqual False (isWordCorrect ["abch"] ('a',"bcdefg") "abch"))
   ]

test_allAnswers :: TestSuite
test_allAnswers =
    [ ("test_allAnswersBasic0",testEqual ["abc","abcdefg"] (sort (allAnswers ["abc","abcdefg"] ('a',"bcdefg"))))
     ,("test_allAnswersBasic1",testEqual ["abc","abcdefg"] (sort (allAnswers ["abc","abcdefg","zxc"] ('a',"bcdefg"))))
     ]

test_finalScore :: TestSuite
test_finalScore =
    [ ("test_finalScoreBasic0",testEqual Zero (finalScore ["abc","abcdefg"] ('a',"bcdefg") []))
     ,("test_finalScoreBasic1",testEqual Good (finalScore ["abc","abcdefg","zxc"] ('a',"bcdefg") ["abc"]))
     ,("test_finalScoreBasic2",testEqual Perfect (finalScore ["abc","abcdefg","zxc"] ('a',"bcdefg") ["abc","abcdefg"]))
      ]

test_cheat :: TestSuite
test_cheat =
    [ ("test_cheatBasic0",testEqual ["abc","bc","c"] (sort (cheat (\p s -> p == ('c',"abdefg") && (s == "abc" || s == "bc" || s == "c")) 3 ('c',"abdefg"))))
     ,("test_cheatBasic1",testEqual ["a","ab","abc"] (sort (cheat (\p s -> p == ('a',"bcdefg") && (s == "abc" || s == "ab" || s == "a")) 3 ('a',"bcdefg"))))
      ]

allTests = test_toCandidateBasis ++ test_extractBases ++ test_basisToPuzzle ++ test_isWordCorrect ++ test_allAnswers ++ test_finalScore ++ test_cheat
