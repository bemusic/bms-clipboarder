
import BMSClipboard
import System.Environment
import Data.List
import Debug.Trace
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

movePlayableNotesToBGM ([], bgmNotes) = bgmNotes

movePlayableNotesToBGM ((noteToMove:otherPlayableNotes), bgmNotes) = let
    availableBGMChannels = iterate (+ 1) 1
    matching channel note = ((row note) == (row noteToMove)) && (isBGM note) && ((bgmChannelIndex note) == channel)
    usable channel = isNothing $ find (matching channel) bgmNotes
    Just channelIndexToMoveTo = find usable availableBGMChannels
    movedNote = (setBGMChannel channelIndexToMoveTo) . (setLength 0) $ noteToMove
  in
    movePlayableNotesToBGM (otherPlayableNotes, (movedNote:bgmNotes))

bgmize objects = let
    sortedObjects = sortBy sortObject objects
    (bgmNotes, playableNotes) = partition isBGM sortedObjects
  in
    OK "Moved notes!" (movePlayableNotesToBGM (playableNotes, bgmNotes))

main = do
    contents <- getContents
    putStrLn $ processBMSClipboard bgmize contents
