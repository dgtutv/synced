module WarnedArithmetic(Warning(..),Expr(..),evaluate) where

import WarningAccumulatorMonad

data Warning = DivByZero | AddByNaN
   deriving (Show,Eq)

{- Hint: If the second input is x2, check if x2 == 0.0 -}
warningDivide :: Float -> Float -> WarningAccumulator Warning Float
warningDivide = error "Unimplemented"

{- Hint: use the isNaN function -}
warningPlus :: Float -> Float -> WarningAccumulator Warning Float
warningPlus = error "Unimplemented"

data Expr =
     Base Float
   | Divide (Expr,Expr)
   | Plus (Expr,Expr)
   deriving (Show,Eq)

evaluateHelper :: Expr -> WarningAccumulator Warning Float
evaluateHelper = error "Unimplemented"

evaluate :: Expr -> (Float,[Warning])
evaluate e =
   let res = evaluateHelper e in
   (getResult res, getWarnings res)