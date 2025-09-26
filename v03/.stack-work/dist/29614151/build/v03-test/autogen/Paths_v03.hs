{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
#if __GLASGOW_HASKELL__ >= 810
{-# OPTIONS_GHC -Wno-prepositive-qualified-module #-}
#endif
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -w #-}
module Paths_v03 (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where


import qualified Control.Exception as Exception
import qualified Data.List as List
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude


#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir `joinFileName` name)

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath




bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath
bindir     = "C:\\Users\\dgtut\\OneDrive - Simon Fraser University (1sfu)\\Desktop\\CMPT 383\\docker\\synced\\v03\\.stack-work\\install\\d8d87e04\\bin"
libdir     = "C:\\Users\\dgtut\\OneDrive - Simon Fraser University (1sfu)\\Desktop\\CMPT 383\\docker\\synced\\v03\\.stack-work\\install\\d8d87e04\\lib\\x86_64-windows-ghc-9.6.7\\v03-0.1.0.0-4sXMWYDSUh1AM4R9h88rHn-v03-test"
dynlibdir  = "C:\\Users\\dgtut\\OneDrive - Simon Fraser University (1sfu)\\Desktop\\CMPT 383\\docker\\synced\\v03\\.stack-work\\install\\d8d87e04\\lib\\x86_64-windows-ghc-9.6.7"
datadir    = "C:\\Users\\dgtut\\OneDrive - Simon Fraser University (1sfu)\\Desktop\\CMPT 383\\docker\\synced\\v03\\.stack-work\\install\\d8d87e04\\share\\x86_64-windows-ghc-9.6.7\\v03-0.1.0.0"
libexecdir = "C:\\Users\\dgtut\\OneDrive - Simon Fraser University (1sfu)\\Desktop\\CMPT 383\\docker\\synced\\v03\\.stack-work\\install\\d8d87e04\\libexec\\x86_64-windows-ghc-9.6.7\\v03-0.1.0.0"
sysconfdir = "C:\\Users\\dgtut\\OneDrive - Simon Fraser University (1sfu)\\Desktop\\CMPT 383\\docker\\synced\\v03\\.stack-work\\install\\d8d87e04\\etc"

getBinDir     = catchIO (getEnv "v03_bindir")     (\_ -> return bindir)
getLibDir     = catchIO (getEnv "v03_libdir")     (\_ -> return libdir)
getDynLibDir  = catchIO (getEnv "v03_dynlibdir")  (\_ -> return dynlibdir)
getDataDir    = catchIO (getEnv "v03_datadir")    (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "v03_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "v03_sysconfdir") (\_ -> return sysconfdir)



joinFileName :: String -> String -> FilePath
joinFileName ""  fname = fname
joinFileName "." fname = fname
joinFileName dir ""    = dir
joinFileName dir fname
  | isPathSeparator (List.last dir) = dir ++ fname
  | otherwise                       = dir ++ pathSeparator : fname

pathSeparator :: Char
pathSeparator = '\\'

isPathSeparator :: Char -> Bool
isPathSeparator c = c == '/' || c == '\\'
