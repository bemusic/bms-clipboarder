
import BMSClipboard
import System.Environment
import Data.List
import Data.Maybe

sortObject a b
    | t1 < t2 = LT
    | t1 > t2 = GT
    | otherwise = compare c1 c2
  where
    t1 = row(a)
    t2 = row(b)
    c1 = rawChannel(a)
    c2 = rawChannel(b)

move (object, movement)
    | (movement == 'z') = move 1
    | (movement == 's') = move 2
    | (movement == 'x') = move 3
    | (movement == 'd') = move 4
    | (movement == 'c') = move 5
    | (movement == 'f') = move 6
    | (movement == 'v') = move 7
    | (movement == 'a') = move 0
    | otherwise = object
  where
    move index = setPlayerChannel index object

moveNotes script objects = let
    sortedObjects = sortBy sortObject objects
    objectsWithMovements =
        zip sortedObjects (script ++ rest)
      where
        rest = ' ':rest
  in
    OK "Moved notes!" (map move objectsWithMovements)

main = do
    contents <- getContents
    (script:_) <- getArgs
    putStrLn $ processBMSClipboard (moveNotes script) contents
