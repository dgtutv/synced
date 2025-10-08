module WarningAccumulatorMonad (WarningAccumulator (..), getResult, getWarnings) where

newtype WarningAccumulator w a = WarningAccumulator (a, [w])
  deriving (Show, Eq)

getResult :: WarningAccumulator w a -> a
getResult (WarningAccumulator (x, ws)) = x

getWarnings :: WarningAccumulator w a -> [w]
getWarnings (WarningAccumulator (x, ws)) = ws

instance Functor (WarningAccumulator w) where
  fmap f (WarningAccumulator (a, w)) = WarningAccumulator (f a, w)

instance Applicative (WarningAccumulator w) where
  pure a = WarningAccumulator (a, [])
  (WarningAccumulator (a1, w1)) <*> (WarningAccumulator (a2, w2)) = WarningAccumulator (a1 a2, w1 ++ w2)

instance Monad (WarningAccumulator w) where
  return = pure
  (>>=) = error "Unimplemented"