module AssocListTest (
  allTests
) where

import TestingFramework
import AssocList

test_fmap :: TestSuite
test_fmap =
  [ ("test_fmapAssocListBasic0",testEqual (Nil :: AssocList String String) (fmap show (Nil :: AssocList String Int)))
   ,("test_fmapAssocListBasic1",testEqual (Cons("key","1",Nil)) (fmap show (Cons("key",1,Nil))))
   ,("test_fmapAssocListBasic2",testEqual (Cons("key",2,Nil)) (fmap (+1) (Cons("key",1,Nil))))
   ,("test_fmapAssocListBasic3",testEqual (Cons("key1",2,Cons("key2",3,Nil))) (fmap (+1) (Cons("key1",1,Cons("key2",2,Nil))))) 
  ]

test_doubleMap :: TestSuite
test_doubleMap =
  [ ("test_doubleMapAssocListBasic0",testEqual (Nil :: AssocList String String) (doubleMap (\_ _ -> error "Not Called") (Nil :: AssocList String Int)))
   ,("test_doubleMapAssocListBasic1",testEqual (Cons(2,"1",Nil)) (doubleMap (\x y -> (y,x)) (Cons("1",2,Nil))))
   ,("test_doubleMapAssocListBasic2",testEqual (Cons(1,"12",Nil)) (doubleMap (\x y -> (x,show x ++ y)) (Cons(1,"2",Nil))))
   ,("test_doubleMapAssocListBasic3",testEqual (Cons(1,3,Cons(3,7,Nil))) (doubleMap (\x y -> (x,x+y)) (Cons(1,2,Cons(3,4,Nil)))))
  ]

allTests = test_fmap ++ test_doubleMap