module SwitchableStackTests (
  allTests
) where

import SwitchableStack
import TestingFramework
import Data.Maybe
import Data.Char

pushList :: (Eq a) => State a -> [a] -> State a
pushList s es = foldr (flip push) s es

popN :: (Eq a) => State a -> Int -> [a]
popN s i = mapMaybe id (popN' s i)
  where
    popN' s 0 = []
    popN' s n = 
      let (vo,s') = pop s in
      vo:(popN' s' (n-1))

popNState :: (Eq a) => State a -> Int -> State a
popNState s i = popN' s i
  where
    popN' s 0 = s
    popN' s n = 
      let (_,s') = pop s in
      (popN' s' (n-1))

test_emptypop :: TestSuite
test_emptypop =
  [("test_emptypopBasic",testEqual (Nothing :: Maybe Int) (fst (pop empty)))]

test_pushpop :: TestSuite
test_pushpop =
  [ ("test_pushPopBasic0",testEqual (Just 'a') (fst (pop (push empty 'a'))))
   ,("test_pushPopBasic1",testEqual (Just 2) (fst (pop (pushList empty [2,3,4]))))
   ,("test_pushPopBasic2",testEqual (Just 3) (fst (pop (pushList empty [5,3,5,4]))))
   ,("test_pushPopBasic3",testEqual [3,5]    (popN (pushList empty [5,3,5,4]) 2) ) ]

test_popInactive :: TestSuite
test_popInactive =
  let initial = setInactive empty in
  [ ("test_popInactiveBasic0",testEqual Nothing (fst (pop (push initial 'a'))))
   ,("test_popInactiveBasic1",testEqual Nothing (fst (pop (pushList initial [2,3,4]))))
   ,("test_popInactiveBasic2",testEqual Nothing (fst (pop (pushList initial [5,3,5,4]))))
   ,("test_popInactiveBasic3",testEqual [] (popN (pushList initial [5,3,5,4]) 2)) ]

test_reactivateInactive :: TestSuite
test_reactivateInactive =
  let initial = setInactive empty in
  [ ("test_reactivateInactiveBasic0",testEqual (Just 'a') (fst (pop (setActive (push initial 'a')))))
   ,("test_reactivateInactiveBasic1",testEqual (Just 2) (fst (pop (setActive (pushList initial [2,3,4])))))
   ,("test_reactivateInactiveBasic2",testEqual (Just 3) (fst (pop (setActive (pushList initial [5,3,5,4])))))
   ,("test_reactivateInactiveBasic3",testEqual [3,5]    (popN (setActive (pushList initial [5,3,5,4])) 2)) ]

test_mapState :: TestSuite
test_mapState = do
  [ ("test_mapStateBasic0",testEqual (Just 'A') (fst (pop (mapState toUpper (push empty 'a')))))
   ,("test_mapStateBasic1",testEqual (Just 3) (fst (pop (mapState (+1) (pushList empty [2,3,4])))))
   ,("test_mapStateBasic2",testEqual (Just 5) (fst (pop (mapState (+2) (pushList empty [5,3,5,4])))))
   ,("test_mapStateBasic3",testEqual [0]    (popN (mapState (*0) (pushList empty [5,3,5,4])) 2)) ]

test_popWhere :: TestSuite
test_popWhere = do
  [ ("test_popWhereBasic0",testEqual [] (fst (popWhere (\ _ -> False) (push empty 'a'))))
   ,("test_popWhereBasic1",testEqual [2,4] (fst (popWhere (\x -> x `mod` 2 == 0) (pushList empty [2,3,4]))))
   ,("test_popWhereBasic2",testEqual [3,5] (fst (popWhere (\x -> x `mod` 2 == 1) (pushList empty [5,3,5,4]))))
   ,("test_popWhereBasic3",testEqual Nothing  (fst (pop (snd (popWhere (\ _ -> True) (pushList empty [5,3,5,4])))))) ]

allTests :: TestSuite
allTests = test_emptypop ++ test_pushpop ++ test_popInactive ++ test_reactivateInactive ++ test_mapState ++ test_popWhere