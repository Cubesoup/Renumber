{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE DeriveGeneric #-}

module Main where

import System.Directory
import Data.Char
import Data.List
import Control.Monad

-- for getopt-generics
import Data.Typeable
import GHC.Generics
import System.Console.GetOpt.Generics
import System.Environment

----------------------------
-- getopt-generics things --
----------------------------

data Options = Options { num  :: Int 
                       , dir  :: Maybe FilePath }
    deriving (Show, GHC.Generics.Generic)

instance System.Console.GetOpt.Generics.Generic Options
instance HasDatatypeInfo Options

helpModifiers :: [Modifier]
helpModifiers = [
  AddOptionHelp "dir" "the directory you want to renumber things in, defaults to the current directory" ,
  AddOptionHelp "num" "number to begin renumbering from, must be supplied" ]

-------------------------------------
-- main function and program logic --
-------------------------------------

main :: IO ()
main = do
  originalLocation <- getCurrentDirectory
  options <- modifiedGetArguments helpModifiers
  when ((dir options) /= Nothing)
       (setCurrentDirectory ((\(Just x) -> x) (dir options)))
  contents <- getCurrentDirectoryContents
  let renumberables = sortBy compareNumber $ filter hasNumber contents
      newfilenames = zipWith (++) (map show2 [(num options)..])
                                  (map (drop 2) renumberables)
  zipWithM_ renameFile renumberables newfilenames
  setCurrentDirectory originalLocation

show2 :: Int -> String
show2 x | (x < 0) || (x > 99) = error "can only renumber in range [0..99]"
        | (x < 10)  = '0' : (show x)
        | otherwise = show x 

compareNumber :: String -> String -> Ordering
compareNumber x y = compare (read (take 2 x) :: Int) (read (take 2 y) :: Int)

hasNumber :: String -> Bool
hasNumber x | length x < 2 = False
            | otherwise    = all isDigit (take 2 x)
             

getCurrentDirectoryContents :: IO [FilePath]
getCurrentDirectoryContents = do
  path <- getCurrentDirectory
  getDirectoryContents path


