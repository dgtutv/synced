{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}

module Language where

import Data.Maybe

data Expression =
      EAnd (Expression,Expression)
    | EOr (Expression,Expression)
    | ENot Expression
    | EVariable String
    | EBase Bool
    deriving (Ord,Eq)

expressionSize :: Expression -> Int
expressionSize (EAnd (e1,e2)) = 1+expressionSize e1+expressionSize e2
expressionSize (EOr (e1,e2)) = 1+expressionSize e1+expressionSize e2
expressionSize (ENot e) = 1+expressionSize e
expressionSize (EVariable _) = 1
expressionSize (EBase _) = 1

newtype Assignment = Assignment [(String,Bool)]
newtype Context = Context [String]

evaluate :: Assignment -> Expression -> Bool
evaluate ass (EAnd(e1,e2)) = evaluate ass e1 && evaluate ass e2
evaluate ass (EOr(e1,e2))  = evaluate ass e1 || evaluate ass e2
evaluate ass (ENot e)      = not (evaluate ass e)
evaluate _   (EBase b)     = b
evaluate (Assignment ctx) (EVariable s) = fromJust (lookup s ctx)

instance Show Expression where
    show (EAnd (e1,e2)) = "(" ++ show e1 ++ "/\\" ++ show e2 ++ ")"
    show (EOr (e1,e2)) = show e1 ++ "\\/" ++ show e2
    show (ENot e) = "~(" ++ show e ++ ")"
    show (EVariable s) = s
    show (EBase b) = show b

typecheck :: Context -> Expression -> Bool
typecheck ctx (EAnd(e1,e2)) = typecheck ctx e1 && typecheck ctx e2
typecheck ctx (EOr(e1,e2))  = typecheck ctx e1 && typecheck ctx e2
typecheck ctx (ENot e)      = typecheck ctx e
typecheck _   (EBase _)     = True
typecheck (Context ctx) (EVariable s) = s `elem` ctx

newtype Examples = Examples [(Assignment,Bool)]