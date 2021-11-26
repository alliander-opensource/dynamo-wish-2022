module Puzzle.Configuration exposing (Cell, Main, Puzzle, Shuffle)


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
