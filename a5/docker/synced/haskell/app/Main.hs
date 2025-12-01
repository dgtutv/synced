module Main where

import Language 
import Lib

program :: Expr ()
program = (mkDouble (mkVec
            [mkInt 10, 
             mkAdd (mkInt 20) (mkInt 22), 
             mkInt 30]))

main :: IO ()
main = do
  result <- evaluate program
  putStrLn $ "Result: " ++ show result
