module ListHOFsTests (
  allTests
) where

import TestingFramework
import ListHOFs

test_zip :: [Test]
test_zip = do
  [("test_zipBasic0",testEqual Nothing (ListHOFs.zip [0,1] ['a']))
    ,("test_zipBasic1",testEqual (Just [(0,'a'),(1,'b')]) (ListHOFs.zip [0,1] ['a','b']))]

test_alternatingMap :: [Test]
test_alternatingMap = do
  [("test_alternatingMapBasic0",testEqual [10] (alternatingMap (+10) (+100) [0]))
    ,("test_alternatingMapBasic1",testEqual [10,101,12] (alternatingMap (+10) (+100) [0,1,2]))]

test_sumEvens :: [Test]
test_sumEvens = do
  [("test_sumEvensBasic0",testEqual 0 (sumEvens []))
    ,("test_sumEvensBasic1",testEqual 16 (sumEvens [2,3,3,5,6,7,8]))]

test_flatten :: [Test]
test_flatten = do
  [("test_flattenBasic0",testEqual [0] (flatten [[0]]))
    ,("test_flattenBasic1",testEqual [0,1,2,3] (flatten [[0],[1,2],[3]]))]

allTests = test_zip ++ test_alternatingMap ++ test_sumEvens ++ test_flatten
