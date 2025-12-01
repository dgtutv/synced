module Lib (typecheck,evaluate) where

import Foreign
import Language
import Helpers

typecheck :: Expr () -> Maybe TypedExpr
typecheck = error "Unimplemented"

evaluate :: Expr () -> IO (Maybe String)
evaluate = error "Unimplemented"