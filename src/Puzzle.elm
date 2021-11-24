module Puzzle exposing (Cell(..), Msg, Puzzle, isSolved, new, slide, update)

import Array exposing (Array)
import Array.Util exposing (all, find, zip)


type Puzzle
    = Puzzle
        { columns : Int
        , rows : Int
        , state : Array Cell
        }


type Cell
    = Blank
    | Cell Int


new : Int -> Int -> Puzzle
new columns rows =
    Puzzle
        { columns = columns
        , rows = rows
        , state = emptyState <| columns * rows
        }


emptyState : Int -> Array Cell
emptyState n =
    let
        cellAt index =
            if index == n - 1 then
                Blank

            else
                Cell index
    in
    Array.initialize n cellAt


isSolved : Puzzle -> Bool
isSolved (Puzzle { columns, rows, state }) =
    let
        fresh =
            emptyState <| columns * rows

        equal ( left, right ) =
            left == right
    in
    zip fresh state
        |> all equal


slide : Cell -> Puzzle -> Puzzle
slide cell puzzle =
    if isAdjacentToBlank cell puzzle then
        swapWithBlank cell puzzle

    else
        puzzle


isAdjacentToBlank : Cell -> Puzzle -> Bool
isAdjacentToBlank =
    areAdjacent Blank


areAdjacent : Cell -> Cell -> Puzzle -> Bool
areAdjacent left right (Puzzle { columns, rows, state }) =
    let
        leftLocation =
            find left state

        rightLocation =
            find right state
    in
    case ( leftLocation, rightLocation ) of
        ( Just l, Just r ) ->
            horizontalAdjacent columns l r || verticalAdjacent columns rows l r

        _ ->
            False


horizontalAdjacent : Int -> Int -> Int -> Bool
horizontalAdjacent columns i j =
    let
        columnOfI =
            modBy columns i
    in
    (columnOfI == 0 && j == i + 1)
        || (columnOfI == columns - 1 && j == i - 1)
        || (not (columnOfI == 0 || columnOfI == columns - 1) && (j == i - 1 || j == i + 1))


verticalAdjacent : Int -> Int -> Int -> Int -> Bool
verticalAdjacent columns rows i j =
    let
        rowOfI =
            modBy rows i
    in
    (rowOfI == 0 && j == i + columns)
        || (rowOfI == rows - 1 && j == i - columns)
        || (not (rowOfI == 0 || rowOfI == rows - 1) && (j == i - columns || j == i + columns))


swapWithBlank : Cell -> Puzzle -> Puzzle
swapWithBlank =
    swap Blank


swap : Cell -> Cell -> Puzzle -> Puzzle
swap left right ((Puzzle ({ state } as puzzle)) as original) =
    let
        leftLocation =
            find left state

        rightLocation =
            find right state
    in
    case ( ( leftLocation, leftLocation |> Maybe.andThen (\l -> Array.get l state) ), ( rightLocation, rightLocation |> Maybe.andThen (\r -> Array.get r state) ) ) of
        ( ( Just l, Just u ), ( Just r, Just v ) ) ->
            let
                nextState =
                    state
                        |> Array.set l v
                        |> Array.set r u
            in
            Puzzle { puzzle | state = nextState }

        _ ->
            original


type Msg
    = Slide Cell


update : Msg -> Puzzle -> Puzzle
update message puzzle =
    case message of
        Slide cell ->
            slide cell puzzle
