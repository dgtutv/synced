module Lib (typecheck, evaluate) where

import Foreign
import Foreign.C
import Helpers
import Language

-- FFI declarations for functions in Rust
foreign import ccall "vec_push" vecPush :: Ptr Value -> Ptr Value -> IO ()\
foreign import ccall "add_values" addValues :: Ptr Value -> Ptr Value -> IO (Ptr Value)
foreign import ccall "head_value" headValue :: Ptr Value -> IO (Ptr Value)
foreign import ccall "double_value" doubleValue :: Ptr Value -> IO (Ptr Value)

-- Helper functions for creating values
createInt :: Int -> IO (Ptr Value)
createInt n = newInt (fromIntegral n)

createVec :: [Ptr Value] -> IO (Ptr Value)
createVec vs = do
  vec <- newVec
  mapM_ (vecPush vec) vs
  return vec

-- Typechecking
typecheck :: Expr () -> Maybe TypedExpr
typecheck (EInt (_, n)) =
  Just (EInt (TInt, n))
typecheck (EVec (_, es)) = do
  typedEs <- mapM typecheck es
  if all isInt typedEs
    then Just (EVec (TVec, typedEs))
    else Nothing
  where
    isInt (EInt (TInt, _)) = True
    isInt _ = False
typecheck (EAdd (_, e1, e2)) = do
  t1 <- typecheck e1
  t2 <- typecheck e2
  if isInt t1 && isInt t2
    then Just (EAdd (TInt, t1, t2))
    else Nothing
  where
    isInt (EInt (TInt, _)) = True
    isInt _ = False
typecheck (EHead (_, e)) = do
  t <- typecheck e
  if isVec t
    then Just (EHead (TInt, t))
    else Nothing
  where
    isVec (EVec (TVec, _)) = True
    isVec _ = False
typecheck (EDouble (_, e)) = do
  t <- typecheck e
  Just (EDouble (getType t, t))
  where
    getType (EInt (ty, _)) = ty
    getType (EVec (ty, _)) = ty
    getType (EAdd (ty, _, _)) = ty
    getType (EHead (ty, _)) = ty
    getType (EDouble (ty, _)) = ty

-- Evaluation
evaluate :: Expr () -> IO (Maybe String)
evaluate expr =
  case typecheck expr of
    Nothing -> return Nothing
    Just typedExpr -> do
      val <- eval typedExpr
      str <- showValue (typeOf typedExpr) val
      return (Just str)

-- Recursive evaluation
eval :: TypedExpr -> IO (Ptr Value)
eval (EInt (ty, n)) = createInt n
eval (EVec (ty, es)) = do
  vs <- mapM eval es
  createVec vs
eval (EAdd (ty, e1, e2)) = do
  v1 <- eval e1
  v2 <- eval e2
  addValues v1 v2
eval (EHead (ty, e)) = do
  vec <- eval e
  headValue vec
eval (EDouble (ty, e)) = do
  v <- eval e
  case ty of
    TInt -> doubleValue v
    TVec -> do
      doubleVecElements e

-- Helper to double each element in a vector
doubleVecElements :: TypedExpr -> IO (Ptr Value)
doubleVecElements (EVec (TVec, es)) = do
  doubled_es <- mapM (\e -> eval (EDouble (getType e, e))) es
  createVec doubled_es
doubleVecElements e = do
  v <- eval e
  doubleValue v

getType :: TypedExpr -> Type
getType (EInt (t, _)) = t
getType (EVec (t, _)) = t
getType (EAdd (t, _, _)) = t
getType (EHead (t, _)) = t
getType (EDouble (t, _)) = t
