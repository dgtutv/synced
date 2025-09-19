module TreeHOFsTests (
  allTests
) where

import TestingFramework
import TreeHOFs

test_treeMap :: [Test]
test_treeMap =
  [("test_treeMapBasic0",testEqual Leaf (treeMap (+1) Leaf))
    ,("test_treeMapBasic1",testEqual (Node(Leaf,1,Node(Leaf,2,Leaf))) (treeMap (+1) (Node(Leaf,0,Node(Leaf,1,Leaf)))))
    ,("test_treeMapShow",testEqual (Node(Node(Leaf,"0",Leaf),"1",Node(Leaf,"2",Leaf))) (treeMap show (Node(Node(Leaf,0,Leaf),1,Node(Leaf,2,Leaf)))))
    ,("test_treeMapLeanLeft",testEqual (Node(Node(Node(Node(Leaf,30,Leaf),20,Leaf),10,Leaf),0,Leaf)) (treeMap (*10) (Node(Node(Node(Node(Leaf,3,Leaf),2,Leaf),1,Leaf),0,Leaf))))]

test_treeFold :: [Test]
test_treeFold =
  [("test_treeFoldBasic0",testEqual 1 (treeFold (\l v r -> l*v*r) 1 Leaf))
    ,("test_treeFoldBasic1",testEqual [0,1] (treeFold (\l v r -> l++[v]++r) [] (Node(Leaf,0,Node(Leaf,1,Leaf)))))
    ,("test_treeFoldMinus",testEqual 25 (treeFold (\l v r -> (2*l)-(v-(3*r))) 2 (Node(Node(Leaf,5,Leaf),3,Node(Leaf,4,Leaf)))))
    ,("test_treeFoldLeftLean",testEqual [1,5,1,4,1,3,1,2,1,1,1,0,1] (treeFold (\l v r -> l++[v]++r) [1] (Node(Node(Node(Node(Node(Node(Leaf,5,Leaf),4,Leaf),3,Leaf),2,Leaf),1,Leaf),0,Leaf))))]

test_treeHeight :: [Test]
test_treeHeight =
  [("test_treeHeight",testEqual 0 (treeHeight Leaf))
    ,("test_treeHeight",testEqual 2 (treeHeight (Node(Leaf,2,Node(Leaf,1,Leaf)))))
    ,("test_treeHeightBalanced",testEqual 2 (treeHeight (Node(Node(Leaf,3,Leaf),2,Node(Leaf,1,Leaf)))))
    ,("test_treeHeightLeftLean",testEqual 6 (treeHeight (Node(Node(Node(Node(Node(Node(Leaf,5,Leaf),4,Leaf),3,Leaf),2,Leaf),1,Leaf),0,Leaf))))]

test_treeSum :: [Test]
test_treeSum =
  [("test_treeSumBasic0",testEqual 0 (treeSum Leaf))
    ,("test_treeSumBasic1",testEqual 3 (treeSum (Node(Leaf,2,Node(Leaf,1,Leaf)))))
    ,("test_treeSumBasicBalanced",testEqual 6 (treeSum (Node(Node(Leaf,3,Leaf),2,Node(Leaf,1,Leaf)))))
    ,("test_treeSumLeftLean",testEqual 15 (treeSum (Node(Node(Node(Node(Node(Node(Leaf,5,Leaf),4,Leaf),3,Leaf),2,Leaf),1,Leaf),0,Leaf))))]

test_treeSizer :: [Test]
test_treeSizer =
  [("test_treeSizerBasic0",testEqual (Node(Leaf,('a',1),Leaf)) (treeSizer (Node(Leaf,'a',Leaf))))
    ,("test_treeSizerBasic1",testEqual (Node(Node(Leaf,('l',1),Leaf),('v',3),Node(Leaf,('r',1),Leaf))) (treeSizer (Node(Node(Leaf,'l',Leaf),'v',Node(Leaf,'r',Leaf)))))
    ,("test_treeSizerLeftLean",testEqual (Node(Node(Node(Node(Node(Node(Leaf,(5,1),Leaf),(4,2),Leaf),(3,3),Leaf),(2,4),Leaf),(1,5),Leaf),(0,6),Leaf)) (treeSizer (Node(Node(Node(Node(Node(Node(Leaf,5,Leaf),4,Leaf),3,Leaf),2,Leaf),1,Leaf),0,Leaf))))
    ,("test_treeSizerRightLean",testEqual (Node(Leaf,(0,6),Node(Leaf,(1,5),Node(Leaf,(2,4),Node(Leaf,(3,3),Node(Leaf,(4,2),Node(Leaf,(5,1),Leaf))))))) (treeSizer (Node(Leaf,0,Node(Leaf,1,Node(Leaf,2,Node(Leaf,3,Node(Leaf,4,Node(Leaf,5,Leaf)))))))))]

allTests = test_treeMap ++ test_treeFold ++ test_treeHeight ++ test_treeSum ++ test_treeSizer