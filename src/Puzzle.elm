module Puzzle exposing (Cell(..), CellConfiguration, Configuration, Msg, Puzzle, isSolved, new, slide, update, view)

import Array exposing (Array)
import Array.Util as Util exposing (find, zip)
import Css exposing (..)
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attribute
import Html.Styled.Events as Event


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
        |> Util.all equal


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


type alias Configuration =
    { cell : CellConfiguration
    }


view : Configuration -> Puzzle -> Html Msg
view configuration (Puzzle { columns, rows, state }) =
    let
        cells =
            state
                |> Array.map (viewCell configuration.cell)
                |> Array.toList
                |> Html.div
                    [ Attribute.css
                        [ displayFlex
                        , flexWrap wrap
                        , boxSizing contentBox
                        , width <| px <| configuration.cell.size * toFloat columns
                        , height <| px <| configuration.cell.size * toFloat rows
                        ]
                    ]
    in
    Html.div []
        [ cells
        ]


type alias CellConfiguration =
    { size : Float }


viewCell : CellConfiguration -> Cell -> Html Msg
viewCell configuration cell =
    let
        hint =
            case cell of
                Blank ->
                    ""

                Cell index ->
                    String.fromInt (index + 1)
    in
    Html.span
        [ Attribute.css
            [ displayFlex
            , justifyContent center
            , alignItems center
            , boxSizing borderBox
            , width (px configuration.size)
            , height (px configuration.size)
            , borderStyle solid
            , borderWidth (px 1)
            , borderColor (gray 155)
            ]
        , Event.onClick <| Slide cell
        ]
        [ Html.text hint ]


gray : Int -> Color
gray g =
    rgb g g g
