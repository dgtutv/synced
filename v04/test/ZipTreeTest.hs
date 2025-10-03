module ZipTreeTest (
  allTests
) where

import TestingFramework
import ZipTree

test_apply :: TestSuite
test_apply =
  [ ("test_applyZipTreeBasic0",testEqual (Leaf :: Tree String) (Leaf <*> Leaf))
   ,("test_applyZipTreeBasic1",testEqual Leaf (Node(Leaf,(+1),Leaf) <*> Leaf))
   ,("test_applyZipTreeBasic2",testEqual (Leaf :: Tree String) (Leaf <*> Node(Leaf,1,Leaf)))
   ,("test_applyZipTreeBasic3",testEqual (Node(Leaf,3,Leaf)) (Node(Leaf,(+),Leaf) <*> (Node(Leaf,1,Leaf)) <*> (Node(Leaf,2,Leaf))))
   ,("test_applyZipTreeBasic4",testEqual (Node(Leaf,3,Leaf)) (Node(Leaf,(+),Leaf) <*> (Node(Node(Leaf,2,Leaf),1,Leaf)) <*> (Node(Leaf,2,Leaf))))
   ,("test_applyZipTreeBasic5",testEqual (Node(Node(Leaf,2,Leaf),3,Leaf)) (pure (+) <*> (Node(Node(Leaf,1,Leaf),1,Leaf)) <*> (Node(Node(Leaf,1,Leaf),2,Node(Leaf,3,Leaf))))) 
  ]

allTests = test_apply