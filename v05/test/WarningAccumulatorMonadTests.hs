module WarningAccumulatorMonadTests (
  allTests
) where

import TestingFramework
import WarningAccumulatorMonad

test_fmap :: TestSuite
test_fmap =
  [ ("test_fmapBasic0",testEqual (WarningAccumulator ("1",[123]) :: WarningAccumulator Int String) (fmap show (WarningAccumulator (1,[123]))))
   ,("test_fmapBasic1",testEqual (WarningAccumulator (4,[]) :: WarningAccumulator Int Int) (fmap (+1) (WarningAccumulator (3,[]))))
  ]

test_pure :: TestSuite
test_pure =
  [ ("test_pureBasic0",testEqual (WarningAccumulator (1,[]) :: WarningAccumulator String Int) (pure 1))
   ,("test_pureBasic1",testEqual (WarningAccumulator ('a',[]) :: WarningAccumulator String Char) (pure 'a'))
  ]

test_apply :: TestSuite
test_apply =
  [ ("test_applyBasic0",testEqual (WarningAccumulator (1,[123])) (WarningAccumulator ((+1),[]) <*> WarningAccumulator (0,[123])))
   ,("test_applyBasic1",testEqual (WarningAccumulator ("Hello, World!",[1,2,3])) (WarningAccumulator ((++),[1]) <*> WarningAccumulator ("Hello, ",[2]) <*> WarningAccumulator ("World!",[3])))
  ]

test_bind :: TestSuite
test_bind =
  [ ("test_bindBasic0",testEqual (WarningAccumulator (1,[123])) (return 0 >>= (\x -> WarningAccumulator (x+1,[123]))))
   ,("test_bindBasic1",testEqual (WarningAccumulator ("5",[1,2,3])) (return 1 >>= (\x -> (WarningAccumulator (x+2,[1])) >>= (\y -> WarningAccumulator (x+y+1,[2]))) >>= (\x -> WarningAccumulator (show x,[3]))))]

allTests :: TestSuite
allTests = test_fmap ++ test_pure ++ test_apply ++ test_bind