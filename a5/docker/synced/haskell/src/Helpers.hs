module Helpers
  (Value
  ,newInt
  ,newVec
  ,showInt
  ,showVec
  ,freeString
  ,showValue
  ,typeOf) where

import Foreign
import Foreign.C
import Language

data Value

foreign import ccall "new_int" newInt :: CInt -> IO (Ptr Value)
foreign import ccall "new_vec" newVec :: IO (Ptr Value)

foreign import ccall "show_int" showInt :: Ptr Value -> IO CString
foreign import ccall "show_vec" showVec :: Ptr Value -> IO CString
foreign import ccall "free_string" freeString :: CString -> IO ()

showValue :: Type -> Ptr Value -> IO String
showValue t ptr = do
  cstr <- case t of 
    TInt -> showInt ptr 
    TVec -> showVec ptr
  s <- peekCString cstr
  freeString cstr
  return s

typeOf :: Expr Type -> Type 
typeOf (EInt (t,_)) = t
typeOf (EVec (t,_)) = t
typeOf (EAdd (t,_,_)) = t
typeOf (EHead (t,_)) = t
typeOf (EDouble (t,_)) = t