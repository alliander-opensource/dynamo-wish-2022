module Puzzle.Configuration exposing (Hint, Main, Puzzle, Shuffle, decode)

import Base64
import Json.Decode as Decode exposing (Decoder, bool, field, float, int, string)


type alias Main =
    { puzzle : Puzzle
    , image : Image
    , shuffle : Shuffle
    , wish : Wish
    , hints : Hint
    }


type alias Puzzle =
    { columns : Int
    , rows : Int
    }


type alias Image =
    { src : String
    , width : Int
    , height : Int
    }


type alias Shuffle =
    { minimum : Int
    , maximum : Int
    }


type alias Wish =
    { message : String }


type alias Hint =
    { indices : Bool }


decode : Decoder Main
decode =
    Decode.map5 Main
        (field "puzzle" decodePuzzle)
        (field "image" decodeImage)
        (field "shuffle" decodeShuffle)
        (field "wish" decodeWish)
        (field "hints" decodeHint)


decodePuzzle : Decoder Puzzle
decodePuzzle =
    Decode.map2 Puzzle
        (field "columns" int)
        (field "rows" int)


decodeImage : Decoder Image
decodeImage =
    Decode.map3 Image
        (field "src" string)
        (field "width" int)
        (field "height" int)


decodeShuffle : Decoder Shuffle
decodeShuffle =
    Decode.map2 Shuffle
        (field "minimum" int)
        (field "maximum" int)


decodeWish : Decoder Wish
decodeWish =
    Decode.map Wish
        (field "message" base64EncodedString)


base64EncodedString : Decoder String
base64EncodedString =
    let
        decoder input =
            case
                input
                    |> Base64.decode
                    |> Result.map (List.map Char.fromCode >> String.fromList)
            of
                Ok output ->
                    Decode.succeed output

                Err reason ->
                    Decode.fail reason
    in
    string
        |> Decode.andThen decoder


decodeHint : Decoder Hint
decodeHint =
    Decode.map Hint
        (field "indices" bool)
