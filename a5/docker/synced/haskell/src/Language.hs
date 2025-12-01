module Language
  (Type(..)
  ,Expr(..)
  ,mkInt
  ,mkVec
  ,mkAdd
  ,mkHead
  ,mkDouble
  ,TypedExpr) where

data Type = TVec | TInt
  deriving (Show,Eq)

data Expr a
  = EInt (a,Int)
  | EVec (a,[Expr a])
  | EAdd (a,Expr a,Expr a)
  | EHead (a,Expr a)
  | EDouble (a,Expr a)
  deriving (Show,Eq)

mkInt :: Int -> Expr ()
mkInt i = EInt ((),i)

mkVec :: [Expr ()] -> Expr ()
mkVec es = EVec ((),es)

mkAdd :: Expr () -> Expr () -> Expr ()
mkAdd e1 e2 = EAdd ((),e1,e2)

mkHead :: Expr () -> Expr ()
mkHead e = EHead ((),e)

mkDouble :: Expr () -> Expr ()
mkDouble e = EDouble ((),e)

type TypedExpr = Expr Type