module TestingFramework where
import Control.Exception
import Data.List ( intercalate )

type Test = (String,IO TestResult)
type TestSuite = [Test]

tryAny :: IO a -> IO (Either SomeException a)
tryAny = Control.Exception.try

data TestResult =
      Success
    | Failure String
    deriving (Show,Eq)

isSuccess :: TestResult -> Bool
isSuccess Success = True
isSuccess _ = False

testEqual :: (Eq a, Show a) => a -> a -> IO TestResult
testEqual expected actual = do
    v <- tryAny (do
        ev <- evaluate (expected == actual)
        if ev then
            return Success
        else
            return (Failure ("Expected " ++ show expected ++ " but got " ++ show actual)))
    case v of
      Left e -> return (Failure (show e))
      Right b -> return b

runTests :: TestSuite -> IO String
runTests sts =
    let (_,ts) = unzip sts in
    runTests' (sequence ts)
    where
        runTests' rs = do
            v <- rs
            let correct = length $ filter isSuccess v
            let total = length v
            return (show (10 * (fromIntegral correct / fromIntegral total)))

runTestsFeedback :: TestSuite -> IO String
runTestsFeedback sts =
    let (names,ts) = unzip sts in
    runTests' names (sequence ts)
    where
        runTests' names rs = do
            v <- rs
            let zipped = zip names v
            let stringed = map (\ (n,b) -> n ++ ": " ++ show b) zipped
            return (intercalate "\n" stringed)
