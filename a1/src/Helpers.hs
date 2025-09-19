{-# LANGUAGE NoImplicitPrelude #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}

module Helpers
    (   foldl,
        foldr,
        forAll,
        map,
        exists,
        sort,
        dedupAndSort,
        length,
        filter,
        filterMap,
        group,
        groupBy,
        null,
        divide,
        concat,
        concatMap
    ) where

import Prelude hiding (foldl, foldr, init, map, filter, length, LT, EQ, GT, concat, null, concatMap)
import qualified Data.List as List

foldl :: (b -> a -> b) -> b -> [a] -> b
foldl _ acc []    = acc
foldl f acc (h:t) = foldl f (f acc h) t

foldr :: (a -> b -> b) -> b -> [a] -> b
foldr _ init []    = init
foldr f init (h:t) = f h (foldr f init t)

forAll :: (a -> Bool) -> [a] -> Bool
forAll _ []    = True
forAll f (h:t) = f h && forAll f t

exists :: (a -> Bool) -> [a] -> Bool
exists _ []    = False
exists f (h:t) = f h || exists f t

map :: (a -> b) -> [a] -> [b]
map _ [] = []
map f (h:t) = f h:map f t

filter :: (a -> Bool) -> [a] -> [a]
filter _ []    = []
filter f (h:t) = [h | f h] ++ filter f t

filterMap :: (a -> Maybe b) -> [a] -> [b]
filterMap _ []    = []
filterMap f (h:t) = 
    case f h of
        Nothing -> filterMap f t
        Just h' -> h':filterMap f t

data Comparison = LT | EQ | GT
    deriving (Eq, Show)

explicitComparison :: (Ord a) => a -> a -> Comparison
explicitComparison x y =
    if x == y then EQ
    else if x < y then LT
    else GT

sortOn :: (a -> a -> Comparison) -> [a] -> [a]
sortOn _   []     = []
sortOn cmp (x:xs) = 
    sortOn cmp [y | y <- xs, cmp y x == LT || cmp y x == EQ] ++
    [x] ++
    sortOn cmp [y | y <- xs, cmp y x == GT]

sort :: (Ord a) => [a] -> [a]
sort = sortOn explicitComparison

dedupAndSortOn :: (a -> a -> Comparison) -> [a] -> [a]
dedupAndSortOn cmp l = removeAdjacentDupes (sortOn cmp l)
  where removeAdjacentDupes []  = []
        removeAdjacentDupes [x] = [x]
        removeAdjacentDupes (x1:x2:xs) =
            [x1 | cmp x1 x2 /= EQ] ++ removeAdjacentDupes (x2:xs)

dedupAndSort :: Ord a => [a] -> [a]
dedupAndSort = dedupAndSortOn explicitComparison

length :: [a] -> Int 
length []    = 0
length (_:t) = 1+length t

groupBy :: (a -> a -> Bool) -> [a] -> [[a]]
groupBy _  []     =  []
groupBy eq (h:t) = 
    let hs = h:List.filter (eq h) t in
    let non_hs = List.filter (\x -> not (eq x h)) t in
    hs:groupBy eq non_hs

group :: (Eq a) => [a] -> [[a]]
group = groupBy (==)

concat :: [[a]] -> [a]
concat [] = []
concat (l:ls) = l ++ concat ls

concatMap :: (a -> [b]) -> [a] -> [b]
concatMap f l = concat (map f l)

null :: [a] -> Bool
null [] = True
null _  = False

divide :: Int -> Int -> Float
divide i1 i2 = fromIntegral i1 / fromIntegral i2