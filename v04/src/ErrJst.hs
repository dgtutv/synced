module ErrJst(ErrJst(..)) where

data ErrJst e a = 
     Err e
   | Jst a
   deriving (Eq,Show)

instance Functor (ErrJst e) where
   fmap = error "Unimplemented"


instance Applicative (ErrJst e) where
   pure = error "Unimplemented"
   (<*>) = error "Unimplemented"