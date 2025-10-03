module Main ( main ) where

import qualified AssocListTest
import qualified ErrJstTest
import qualified ZipTreeTest

import TestingFramework

allTests :: TestSuite
allTests = AssocListTest.allTests ++ ErrJstTest.allTests ++ ZipTreeTest.allTests

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
