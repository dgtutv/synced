module InterpreterTests (
  allTests
) where

import TestingFramework
import Language
import Lib 
import GHC.IO (unsafePerformIO)

test_typecheck :: TestSuite
test_typecheck =
    [("test_typecheckInt", testEqual (Just (EInt (TInt,2))) (typecheck (mkInt 2)))
    ,("test_typecheckVec", testEqual (Just (EVec (TVec,[EInt (TInt,2)]))) (typecheck (mkVec [mkInt 2])))
    ,("test_typecheckVecF", testEqual Nothing (typecheck (mkVec [mkVec [mkInt 2]])))
    ,("test_typecheckDoubleI", testEqual (Just (EDouble (TInt,EInt (TInt,2)))) (typecheck (mkDouble (mkInt 2))))
    ,("test_typecheckDoubleV", testEqual (Just (EDouble (TVec,EVec (TVec,[EInt (TInt,2)])))) (typecheck (mkDouble (mkVec [mkInt 2]))))
    ]

test_evaluate :: TestSuite
test_evaluate =
    [("test_evaluateInt", testEqual (Just "2") (unsafePerformIO (evaluate (mkInt 2))))
    ,("test_evaluateVec", testEqual (Just "[2]") (unsafePerformIO (evaluate (mkVec [mkInt 2]))))
    ,("test_evaluateVecF", testEqual Nothing (unsafePerformIO (evaluate (mkVec [mkVec [mkInt 2]]))))
    ,("test_evaluateDoubleI", testEqual (Just "4") (unsafePerformIO (evaluate (mkDouble (mkInt 2)))))
    ,("test_evaluateDoubleV", testEqual (Just "[4]") (unsafePerformIO (evaluate (mkDouble (mkVec [mkInt 2])))))
    ,("test_evaluateHead", testEqual (Just "2") (unsafePerformIO (evaluate (mkHead (mkVec [mkInt 2])))))
    ]


allTests :: TestSuite
allTests = test_typecheck ++ test_evaluate
