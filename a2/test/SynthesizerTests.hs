module SynthesizerTests (
  allTests
) where

import TestingFramework
import qualified Language
import Data.List
import Language
import Synthesizer
import qualified Data.Foldable as Language
import Data.Bits (Bits(xor))

test_numberSplit :: TestSuite
test_numberSplit =
    [ ("test_numberSplitBasic0", testEqual [] (sort (numberSplit 0)))
    , ("test_numberSplitBasic1", testEqual [] (sort (numberSplit 1)))
    , ("test_numberSplitBasic2", testEqual [(1,1)] (sort (numberSplit 2)))
    , ("test_numberSplitBasic3", testEqual [(1,2),(2,1)] (sort (numberSplit 3)))
    , ("test_numberSplitBasic4", testEqual [(1,3),(2,2),(3,1)] (sort (numberSplit 4)))]

test_baseExpressionsAtSize :: TestSuite
test_baseExpressionsAtSize =
    [ ("test_baseExpressionsAtSizeBasic0", testEqual [] (sort (baseExpressionsAtSize 0)))
    , ("test_baseExpressionsAtSizeBasic1", testEqual [EBase False,EBase True] (sort (baseExpressionsAtSize 1)))
    , ("test_baseExpressionsAtSizeBasic2", testEqual [] (sort (baseExpressionsAtSize 2)))]

test_varExpressionsAtSize :: TestSuite
test_varExpressionsAtSize =
    [ ("test_varExpressionsAtSizeBasic0", testEqual [] (sort (varExpressionsAtSize (Context ["a","b"]) 0)))
    , ("test_varExpressionsAtSizeBasic1", testEqual [EVariable "a",EVariable "b"] (sort (varExpressionsAtSize (Context ["a","b"]) 1)))
    , ("test_varExpressionsAtSizeBasic2", testEqual [EVariable "a1",EVariable "a2",EVariable "a3"] (sort (varExpressionsAtSize (Context ["a1","a2","a3"]) 1)))
    , ("test_varExpressionsAtSizeBasic3", testEqual [] (sort (varExpressionsAtSize (Context ["a1","a2","a3"]) 2)))]

test_notExpressionsAtSize :: TestSuite
test_notExpressionsAtSize =
    [ ("test_notExpressionsAtSizeBasic0", testEqual [] (sort (notExpressionsAtSize (\ _ -> [EBase True]) 0)))
    , ("test_notExpressionsAtSizeBasic1", testEqual 
        [ENot (EBase False), ENot (EBase True)] 
        (sort 
            (notExpressionsAtSize 
                (\ i -> if i == 1 then [EBase True,EBase False] else []) 
                2)))
    , ("test_notExpressionsAtSizeBasic2", testEqual
        [] 
        (sort 
            (notExpressionsAtSize 
                (\ i -> if i == 1 then [EBase True,EBase False] else [])
                3))) ]

test_andExpressionsAtSize :: TestSuite
test_andExpressionsAtSize =
    [ ("test_andExpressionsAtSizeBasic0", testEqual 
        [EAnd (EBase False,EBase False)
        ,EAnd (EBase False,EBase True)
        ,EAnd (EBase True,EBase False)
        ,EAnd (EBase True, EBase True)]
        (sort
            (andExpressionsAtSize 
                (\ i -> if i == 1 then 
                        [EBase True,EBase False] 
                    else if i == 2 then 
                        [ENot (EBase True),ENot (EBase False)] 
                    else []) 
                3)))
    , ("test_andExpressionsAtSizeBasic1", testEqual 
        [EAnd (ENot (EBase False),EBase False)
        ,EAnd (ENot (EBase False),EBase True)
        ,EAnd (ENot (EBase True),EBase False)
        ,EAnd (ENot (EBase True), EBase True)
        ,EAnd (EBase False,ENot (EBase False))
        ,EAnd (EBase False,ENot (EBase True))
        ,EAnd (EBase True,ENot (EBase False))
        ,EAnd (EBase True, ENot (EBase True))] 
        (sort
            (andExpressionsAtSize 
                (\ i -> if i == 1 then 
                        [EBase True,EBase False] 
                    else if i == 2 then 
                        [ENot (EBase True),ENot (EBase False)] 
                    else []) 
                4))) ]

test_orExpressionsAtSize :: TestSuite
test_orExpressionsAtSize =
    [ ("test_orExpressionsAtSizeBasic0", testEqual 
        [EOr (EBase False,EBase False)
        ,EOr (EBase False,EBase True)
        ,EOr (EBase True,EBase False)
        ,EOr (EBase True, EBase True)]
        (sort
            (orExpressionsAtSize 
                (\ i -> if i == 1 then 
                        [EBase True,EBase False] 
                    else if i == 2 then 
                        [ENot (EBase True),ENot (EBase False)] 
                    else []) 
                3)))
    , ("test_orExpressionsAtSizeBasic1", testEqual 
        [EOr (ENot (EBase False),EBase False)
        ,EOr (ENot (EBase False),EBase True)
        ,EOr (ENot (EBase True),EBase False)
        ,EOr (ENot (EBase True), EBase True)
        ,EOr (EBase False,ENot (EBase False))
        ,EOr (EBase False,ENot (EBase True))
        ,EOr (EBase True,ENot (EBase False))
        ,EOr (EBase True, ENot (EBase True))]
        (sort
            (orExpressionsAtSize 
                (\ i -> if i == 1 then 
                        [EBase True,EBase False] 
                    else if i == 2 then 
                        [ENot (EBase True),ENot (EBase False)] 
                    else []) 
                4))) ]

test_expressionsAtSize :: TestSuite
test_expressionsAtSize =
    [ ("test_expressionsAtSizeBasic0", testEqual [] (expressionsAtSize (Context []) 0))
    , ("test_expressionsAtSizeBasic1", testEqual 
        [EBase False,EBase True]
        (sort (expressionsAtSize (Context []) 1)))
    , ("test_expressionsAtSizeBasic2", testEqual 
        [EVariable "a", EVariable "b", EBase False,EBase True]
        (sort (expressionsAtSize (Context ["a","b"]) 1)))
    , ("test_expressionsAtSizeBasic3", testEqual 
        [ENot (EVariable "a"), ENot (EVariable "b"), ENot (EBase False),ENot (EBase True)]
        (sort (expressionsAtSize (Context ["a","b"]) 2)))
    , ("test_expressionsAtSizeBasic4", testEqual 
        [EAnd (EBase False,EBase False), EAnd (EBase False,EBase True), EAnd (EBase True,EBase False),EAnd (EBase True,EBase True)
        ,EOr (EBase False,EBase False), EOr (EBase False,EBase True), EOr (EBase True,EBase False),EOr (EBase True,EBase True)
        ,ENot (ENot (EBase False)),ENot (ENot (EBase True))]
        (sort (expressionsAtSize (Context []) 3))) ]

test_expressionSatisfiesExamples :: TestSuite
test_expressionSatisfiesExamples =
    [ ("test_expressionSatisfiesExamplesBasic0", testEqual True (expressionSatisfiesExamples (Examples [(Assignment [],True)]) (EBase True)))
    , ("test_expressionSatisfiesExamplesBasic1", testEqual False (expressionSatisfiesExamples (Examples [(Assignment [],True)]) (EBase False)))
    , ("test_expressionSatisfiesExamplesBasic2", testEqual False (expressionSatisfiesExamples (Examples [(Assignment [],False)]) (EBase True)))
    , ("test_expressionSatisfiesExamplesBasic3", testEqual True (expressionSatisfiesExamples (Examples [(Assignment [],False)]) (EBase False)))
    , ("test_expressionSatisfiesExamplesBasic4", testEqual True (expressionSatisfiesExamples (Examples []) (EBase False)))
    , ("test_expressionSatisfiesExamplesBasic5", testEqual True (expressionSatisfiesExamples (Examples []) (EBase True)))
    , ("test_expressionSatisfiesExamplesBasic6", testEqual True (expressionSatisfiesExamples (Examples [(Assignment [("a",True)],True),(Assignment [("a",False)],False)]) (EVariable "a"))) ]

test_generator :: TestSuite
test_generator =
    [ ("test_generatorBasic0", testEqual (Just (EBase True)) (generator (Context []) (Examples [(Assignment [],True)]) 1))
    , ("test_generatorBasic1", testEqual (Just (EBase False)) (generator (Context []) (Examples [(Assignment [],False)]) 1))
    , ("test_generatorBasic2", testEqual Nothing (generator (Context []) (Examples [(Assignment [("a",True)],False),(Assignment [("a",False)],True)]) 1))
    , ("test_generatorBasic3", testEqual (Just (ENot (EVariable "a"))) (generator (Context ["a"]) (Examples [(Assignment [("a",True)],False),(Assignment [("a",False)],True)]) 3))
    , ("test_generatorBasic4", testEqual 
        (Just (EAnd ((EVariable "a"),(EVariable "b"))))
        (generator 
            (Context ["a","b"]) 
            (Examples 
                [(Assignment [("a",True),("b",True)],True)
                ,(Assignment [("a",True),("b",False)],False)
                ,(Assignment [("a",False),("b",True)],False)
                ,(Assignment [("a",False),("b",False)],False)
                ]) 4))
    , ("test_generatorBasic5", testEqual 
        Nothing 
        (generator 
            (Context ["a","b"]) 
            (Examples 
                [(Assignment [("a",True),("b",True)],True)
                ,(Assignment [("a",True),("b",False)],False)
                ,(Assignment [("a",False),("b",True)],False)
                ,(Assignment [("a",False),("b",False)],False)
                ]) 2)) ]

allTests :: TestSuite
allTests = test_numberSplit ++ test_baseExpressionsAtSize ++ test_varExpressionsAtSize ++ test_notExpressionsAtSize ++ test_andExpressionsAtSize ++ test_orExpressionsAtSize ++ test_expressionsAtSize ++ test_expressionSatisfiesExamples ++ test_generator
