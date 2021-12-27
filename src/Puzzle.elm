module Puzzle exposing (Cell(..), Msg, Puzzle, isSolved, new, numberOfSlides, shuffle, slide, slideable, update, view)

import Array exposing (Array)
import Array.Util as Util exposing (find, zip)
import Css exposing (..)
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attribute
import Html.Styled.Events as Event
import Puzzle.Configuration as Configuration
import Random exposing (Generator)
import Random.Util exposing (uniquePair)


type Puzzle
    = Puzzle
        { columns : Int
        , rows : Int
        , state : Array Cell
        , slides : Int
        }


type Cell
    = Blank
    | Cell Int


new : Configuration.Puzzle -> Puzzle
new { columns, rows } =
    Puzzle
        { columns = columns
        , rows = rows
        , state = emptyState <| columns * rows
        , slides = 0
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


numberOfSlides : Puzzle -> Int
numberOfSlides (Puzzle { slides }) =
    slides


slide : Cell -> Puzzle -> Puzzle
slide cell puzzle =
    if isAdjacentToBlank cell puzzle then
        puzzle
            |> swapWithBlank cell
            |> incrementSlides

    else
        puzzle


incrementSlides : Puzzle -> Puzzle
incrementSlides (Puzzle ({ slides } as puzzle)) =
    Puzzle { puzzle | slides = slides + 1 }


slideable : Puzzle -> List Cell
slideable ((Puzzle { state }) as puzzle) =
    state
        |> Array.filter (\cell -> isAdjacentToBlank cell puzzle)
        |> Array.toList


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
            i // columns
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


shuffle : Configuration.Shuffle -> Puzzle -> Generator Puzzle
shuffle configuration ((Puzzle { columns, rows }) as puzzle) =
    let
        n =
            columns * rows

        cell =
            Random.uniform (Cell 0) <| (List.range 1 (n - 2) |> List.map Cell)

        minimum =
            if isEven configuration.minimum then
                configuration.minimum

            else
                configuration.minimum + 1

        maximum =
            max (minimum + 2) configuration.maximum
    in
    List.range (minimum + 2) maximum
        |> List.filter isEven
        |> Random.uniform minimum
        |> Random.andThen (\l -> Random.list l <| uniquePair cell)
        |> Random.map (List.foldl (uncurry swap) puzzle)


uncurry : (a -> b -> c) -> ( a, b ) -> c
uncurry f ( a, b ) =
    f a b


isEven : Int -> Bool
isEven n =
    0 == modBy 2 n


type Msg
    = Slide Cell


update : Msg -> Puzzle -> Puzzle
update message puzzle =
    case message of
        Slide cell ->
            slide cell puzzle


view : Configuration.Main -> Puzzle -> Html Msg
view configuration (Puzzle { columns, rows, state }) =
    let
        cells =
            state
                |> Array.map (viewCell configuration)
                |> Array.toList
                |> Html.div
                    [ Attribute.css
                        [ displayFlex
                        , flexWrap wrap
                        , boxSizing contentBox
                        , width <| px <| toFloat configuration.image.width
                        , height <| px <| toFloat configuration.image.height
                        ]
                    ]
    in
    Html.div []
        [ cells
        ]


viewCell : Configuration.Main -> Cell -> Html Msg
viewCell configuration cell =
    let
        indicesHint =
            if configuration.hints.indices then
                case cell of
                    Blank ->
                        ""

                    Cell index ->
                        String.fromInt <| index + 1

            else
                ""

        columns =
            configuration.puzzle.columns

        rows =
            configuration.puzzle.rows

        h =
            toFloat configuration.image.height / toFloat rows

        w =
            toFloat configuration.image.width / toFloat columns

        background =
            case cell of
                Blank ->
                    []

                Cell index ->
                    let
                        dx =
                            index
                                |> modBy columns
                                |> toFloat
                                |> (*) w
                                |> negate

                        row =
                            index // columns

                        dy =
                            row
                                |> toFloat
                                |> (*) h
                                |> negate
                    in
                    [ backgroundImage (url configuration.image.src)
                    , backgroundPosition2 (px dx) (px dy)
                    ]
    in
    Html.span
        [ Attribute.css <|
            List.concat
                [ [ displayFlex
                  , justifyContent left
                  , alignItems top
                  , boxSizing borderBox
                  , width (px w)
                  , height (px h)
                  , borderStyle solid
                  , borderWidth (px 1)
                  , borderColor (gray 155)
                  , color (gray 255)
                  , fontSize (px 10)
                  ]
                , background
                ]
        , Event.onClick <| Slide cell
        ]
        [ Html.text indicesHint ]


gray : Int -> Color
gray g =
    rgb g g g
