
module BMSClipboard
( BMSObject
, BMSProcessResult(..)
, iBMSCParse
, stringify
, isBGM
, processBMSClipboard
, setPlayerChannel
, setBGMChannel
, bgmChannelIndex
, setKeysound
, setLength
, row
, rawChannel
) where

data BMSObject = IBMSCObject { channel :: Int
                             , row :: Int
                             , value :: Int
                             , length :: Int
                             , flag :: Int
                             } deriving (Show)

data BMSProcessResult = OK String [BMSObject]
                      | Error String

-- Converts iBMSC Clipboard line into a BMSObject
iBMSCParse :: String -> BMSObject
iBMSCParse string =
    IBMSCObject { channel = channel
                , row = row
                , value = value
                , BMSClipboard.length = length
                , flag = flag }
  where
    values = map read (words string)
    (channel:row:value:length:flag:[]) = values

-- Converts a BMSObject back into iBMSC
stringify :: BMSObject -> String
stringify object =
    unwords (map (show . ($ object)) [channel, row, value, BMSClipboard.length, flag])

-- Checks if BMSObject is a BGM object
isBGM :: BMSObject -> Bool
isBGM IBMSCObject { channel = c } =
    c >= 26

-- Process the clipboard data with function
processBMSClipboard :: ([BMSObject] -> BMSProcessResult) -> String -> String
processBMSClipboard f clipboardData = let
    (headerLine:objectLines) = lines clipboardData
    result = case headerLine of
        "iBMSC Clipboard Data xNT" -> f (map iBMSCParse objectLines)
        _                          -> Error "Invalid header!"
  in case result of
      OK message outputObjects -> unlines $ ["ok", message, headerLine] ++ (map stringify outputObjects)
      Error message            -> unlines $ ["error", message]

-- Returns an object with channel updated to player channel
setPlayerChannel :: Int -> BMSObject -> BMSObject
setPlayerChannel index object@IBMSCObject { } =
    object { channel = newChannel }
  where
    newChannel = case index of 0 -> 4
                               1 -> 5
                               2 -> 6
                               3 -> 7
                               4 -> 8
                               5 -> 9
                               6 -> 10
                               7 -> 11

-- Returns an object with channel updated to player channel
setBGMChannel :: Int -> BMSObject -> BMSObject
setBGMChannel index object@IBMSCObject { } =
    object { channel = 26 + index - 1 }

-- Returns an index representing BGM channel, starting with 1
bgmChannelIndex :: BMSObject -> Int
bgmChannelIndex IBMSCObject { channel = c }
    | (c >= 26) = c - 26 + 1

-- Set length
setLength :: Int -> BMSObject -> BMSObject
setLength len object@IBMSCObject { } =
    object { BMSClipboard.length = (len * 10000) }

setKeysound :: Int -> BMSObject -> BMSObject
setKeysound index object@IBMSCObject { } =
    object { value = (index * 10000) }


rawChannel = channel
