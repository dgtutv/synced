module Main ( main ) where

import qualified ListHOFsTests
import qualified TreeHOFsTests

import TreeHOFs

import TestingFramework

allTests :: TestSuite
allTests = ListHOFsTests.allTests ++ TreeHOFsTests.allTests

main :: IO ()
main = do
    v1 <- runTests allTests
    v2 <- runTestsFeedback allTests
    putStrLn v1
    putStrLn "\n"
    putStrLn v2
    if v1 == "10.0" then
        return ()
    else
        error "Not fully correct"
