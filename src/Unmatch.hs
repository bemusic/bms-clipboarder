
import BMSClipboard
import Data.List
import Data.Maybe
import Data.Functor

unmatch objects = let
    bgms = filter isBGM objects
    sourceColumns = sort $ nub $ map bgmChannelIndex bgms
    destColumns = take (Data.List.length sourceColumns) [1, 2, 3, 4, 5, 6, 7, 0]
    columnMapping = zip sourceColumns destColumns
    updateNote :: BMSObject -> Maybe BMSObject
    updateNote object = let
        maybeNewChannel = (lookup (bgmChannelIndex object) columnMapping)
        newKeysound = ((bgmChannelIndex object) + 1260)
      in
        (\newChannel -> ((setPlayerChannel newChannel) . (setKeysound newKeysound)) object) <$> maybeNewChannel
  in
    OK "Umatched notes!" (mapMaybe updateNote bgms)

main = do
    contents <- getContents
    putStrLn $ processBMSClipboard unmatch contents
