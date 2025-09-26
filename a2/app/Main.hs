module Main (main) where
    
import Language
import Synthesizer
import System.IO
import Data.Char
import Text.Printf

getExampleLoop :: Context -> IO [(Assignment,Bool)]
getExampleLoop c = do
  e <- getExampleData c []
  putStrLn "Do you want do provide another example? (\"n\" for no, otherwise yes)"
  guessesInput <- getLine
  if words guessesInput == ["n"] then 
    return [e]
  else do
    l <- getExampleLoop c
    return (e:l)
  where 
    getExampleData (Context []) acc = do
      putStrLn "Should the function map to True or False? (\"T\" for True, otherwise False)"
      guessesInput <- getLine
      let output = words guessesInput == ["T"]
      return (Assignment acc,output)
    getExampleData (Context (h:t)) acc = do
      putStrLn (printf "What should variable %s be assigned (\"T\" for True, otherwise False)" h)
      guessesInput <- getLine
      let assignedValue = words guessesInput == ["T"]
      getExampleData (Context t) ((h,assignedValue):acc)



main :: IO ()
main = do
    putStrLn "Input a list of variables as a space-separated list"
    variableInput <- getLine
    let ctx = Context (words variableInput)
    exBasis <- getExampleLoop ctx
    let exs = Examples exBasis
    putStrLn "Input the maximum size of expression you want to generate"
    maxInput <- getLine
    let max = read maxInput :: Int
    let me = generator ctx exs max
    case me of
      Nothing -> putStrLn "Nothing satisfies your specification"
      Just e -> putStrLn (printf "The expression:\n%s\nsatisfies your specification" (show e))
