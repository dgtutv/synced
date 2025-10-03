module ErrJstTest (
  allTests
) where

import TestingFramework
import ErrJst

test_fmap :: TestSuite
test_fmap =
  [ ("test_fmapBasic0",testEqual ((Err "Error") :: ErrJst String String) (fmap show ((Err "Error") :: ErrJst String Int)))
   ,("test_fmapBasic1",testEqual ((Jst "1") :: ErrJst String String) (fmap show ((Jst 1) :: ErrJst String Int)))
   ,("test_fmapBasic2",testEqual ((Jst 2) :: ErrJst String Int) (fmap (+1) ((Jst 1) :: ErrJst String Int))) ]

test_pure :: TestSuite
test_pure =
  [ ("test_pureErrJstBasic0",testEqual ((Jst 1) :: ErrJst String Int) (pure 1))
   ,("test_pureErrJstBasic1",testEqual ((Jst "Hello, World!") :: ErrJst String String) (pure "Hello, World!")) ]

test_apply :: TestSuite
test_apply =
  [ ("test_applyErrJstBasic0",testEqual (Err ("No value") :: ErrJst String Int) ((Jst (+1)) <*> Err ("No value")))
   ,("test_applyErrJstBasic1",testEqual (Err ("No function") :: ErrJst String Int) ((Err "No function") <*> Jst 1))
   ,("test_applyErrJstBasic2",testEqual (Err ("No function") :: ErrJst String Int) ((Err "No function") <*> Err ("No value")))
   ,("test_applyErrJstBasic3",testEqual (Jst 2 :: ErrJst String Int) ((Jst (+1)) <*> Jst 1))
   ,("test_applyErrJstBasic4",testEqual (Jst "1" :: ErrJst String String) ((Jst show) <*> Jst 1))
   ,("test_applyErrJstBasic5",testEqual (Jst "Hello, World!" :: ErrJst Int String) ((Jst (++)) <*> Jst "Hello, " <*> Jst "World!"))
  ]

allTests = test_fmap ++ test_pure ++ test_apply