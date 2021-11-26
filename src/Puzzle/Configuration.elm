module Puzzle.Configuration exposing (Cell, Main, Puzzle, Shuffle, decode)

import Json.Decode as Decode exposing (Decoder, field, float, int)


type alias Main =
    { puzzle : Puzzle
    , cell : Cell
    , shuffle : Shuffle
    }


type alias Puzzle =
    { columns : Int
    , rows : Int
    }


type alias Cell =
    { size : Float }


type alias Shuffle =
    { minimum : Int
    , maximum : Int
    }


decode : Decoder Main
decode =
    Decode.map3 Main
        (field "puzzle" decodePuzzle)
        (field "cell" decodeCell)
        (field "shuffle" decodeShuffle)


decodePuzzle : Decoder Puzzle
decodePuzzle =
    Decode.map2 Puzzle
        (field "columns" int)
        (field "rows" int)


decodeCell : Decoder Cell
decodeCell =
    Decode.map Cell
        (field "size" float)


decodeShuffle : Decoder Shuffle
decodeShuffle =
    Decode.map2 Shuffle
        (field "minimum" int)
        (field "maximum" int)
