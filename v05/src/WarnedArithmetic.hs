module WarnedArithmetic (Warning (..), Expr (..), evaluate) where

import WarningAccumulatorMonad

data Warning = DivByZero | AddByNaN
  deriving (Show, Eq)

{- Hint: If the second input is x2, check if x2 == 0.0 -}
warningDivide :: Float -> Float -> WarningAccumulator Warning Float
warningDivide x y
  | y == 0.0 = WarningAccumulator (x / y, [DivByZero])
  | otherwise = WarningAccumulator (x / y, [])

{- Hint: use the isNaN function -}
warningPlus :: Float -> Float -> WarningAccumulator Warning Float
warningPlus x y
  | isNaN x = WarningAccumulator (x + y, [AddByNaN])
  | isNaN y = WarningAccumulator (x + y, [AddByNaN])
  | otherwise = WarningAccumulator (x + y, [])

data Expr
  = Base Float
  | Divide (Expr, Expr)
  | Plus (Expr, Expr)
  deriving (Show, Eq)

evaluateHelper :: Expr -> WarningAccumulator Warning Float
evaluateHelper (Base f) = WarningAccumulator (f, [])
evaluateHelper (Divide (x, y)) = do
  x' <- evaluateHelper x
  y' <- evaluateHelper y
  warningDivide x' y'
evaluateHelper (Plus (x, y)) = do
  x' <- evaluateHelper x
  y' <- evaluateHelper y
  warningPlus x' y'

evaluate :: Expr -> (Float, [Warning])
evaluate e =
  let res = evaluateHelper e
   in (getResult res, getWarnings res)