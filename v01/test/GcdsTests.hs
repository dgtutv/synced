module GcdsTests where

import TestingFramework
import Gcds

test_isDivisor :: [(String,IO TestResult)]
test_isDivisor =
  [("isDivisorBasic0",testEqual True (isDivisor 2 4))
  ,("isDivisorBasic1",testEqual False (isDivisor 4 2))
  ]

test_allDivisors :: [(String,IO TestResult)]
test_allDivisors =
  [("allDivisorsBasic0",testEqual [2,1] (allDivisors 2))
  ,("allDivisorsBasic1",testEqual [6,3,2,1] (allDivisors 6))
  ]

test_listIntersection :: [(String,IO TestResult)]
test_listIntersection =
  [("listIntersectionBasic0",testEqual [1] (listIntersection [2,1] [1]))
  ,("listIntersectionBasic1",testEqual [2] (listIntersection [2,1] [2]))
  ]

test_listGcd :: [(String,IO TestResult)]
test_listGcd =
  [("listGcdBasic0",testEqual 3 (listGcd 3 6))
  ,("listGcdBasic1",testEqual 4 (listGcd 12 8))
  ,("listGcdBasic2",testEqual 1 (listGcd 1 9))
  ]

allTests :: TestSuite
allTests = test_isDivisor ++ test_allDivisors ++ test_listIntersection ++ test_listGcd
