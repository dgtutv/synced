module WarningAccumulatorMonad(WarningAccumulator(..),getResult,getWarnings) where

newtype WarningAccumulator w a = WarningAccumulator (a,[w])
   deriving (Show,Eq)

getResult :: WarningAccumulator w a -> a
getResult (WarningAccumulator (x,ws)) = x

getWarnings :: WarningAccumulator w a -> [w]
getWarnings (WarningAccumulator (x,ws)) = ws

instance Functor (WarningAccumulator w) where
   fmap = error "Unimplemented"

instance Applicative (WarningAccumulator w) where
   pure = error "Unimplemented"
   (<*>) = error "Unimplemented"

instance Monad (WarningAccumulator w) where
   return = pure
   (>>=) = error "Unimplemented"