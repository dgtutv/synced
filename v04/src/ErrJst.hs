{-# LANGUAGE InstanceSigs #-}

module ErrJst (ErrJst (..)) where

data ErrJst e a
  = Err e -- Error value, usually a string or error integer
  | Jst a -- Non-fail data value
  deriving (Eq, Show)

-- Apply the value of the fmap to data of Jst
-- When performing fmap on Err, return the Err
instance Functor (ErrJst e) where
  fmap :: (a -> b) -> ErrJst e a -> ErrJst e b
  fmap _ (Err e) = Err e
  fmap fn (Jst a) = Jst (fn a)

instance Applicative (ErrJst e) where
  pure = Jst
  (<*>) :: ErrJst e (a -> b) -> ErrJst e a -> ErrJst e b
  (Jst f) <*> (Jst x) = Jst (f x)
  (Err e) <*> _ = Err e
  _ <*> (Err e) = Err e