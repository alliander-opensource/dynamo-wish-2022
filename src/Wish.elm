module Wish exposing (..)

import Browser exposing (Document)
import Css
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attributes
import Html.Styled.Events as Event
import Puzzle exposing (Puzzle)
import Puzzle.Configuration as Configuration
import Random


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : () -> ( Model, Cmd Msg )
init _ =
    let
        configuration =
            { puzzle = { columns = 4, rows = 4 }
            , cell = { size = 50 }
            , shuffle = { minimum = 20, maximum = 50 }
            }

        puzzle =
            Puzzle.new configuration.puzzle
    in
    ( Initializing configuration, Random.generate Challenge <| Puzzle.shuffle configuration.shuffle puzzle )


type Model
    = Initializing Configuration.Main
    | Solving Data
    | Solved Data


type alias Data =
    { puzzle : Puzzle
    , configuration : Configuration.Main
    }


type Msg
    = PuzzleMsg Puzzle.Msg
    | Shuffle
    | Challenge Puzzle


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        PuzzleMsg msg ->
            puzzleOf model
                |> Maybe.map (Puzzle.update msg)
                |> Maybe.map (swap updatePuzzle <| model)
                |> Maybe.withDefault ( model, Cmd.none )

        Shuffle ->
            let
                shuffleCmd puzzle =
                    puzzle
                        |> Puzzle.shuffle (configurationOf model).shuffle
                        |> Random.generate Challenge

                cmd =
                    puzzleOf model
                        |> Maybe.map shuffleCmd
                        |> Maybe.withDefault Cmd.none
            in
            ( model, cmd )

        Challenge puzzle ->
            updatePuzzle puzzle model


swap : (a -> b -> c) -> b -> a -> c
swap f b a =
    f a b


puzzleOf : Model -> Maybe Puzzle
puzzleOf model =
    case model of
        Initializing _ ->
            Nothing

        Solving data ->
            Just data.puzzle

        Solved data ->
            Just data.puzzle


configurationOf : Model -> Puzzle.Configuration
configurationOf model =
    case model of
        Initializing configuration ->
            configuration

        Solving data ->
            data.configuration

        Solved data ->
            data.configuration


updatePuzzle : Puzzle -> Model -> ( Model, Cmd Msg )
updatePuzzle puzzle model =
    case model of
        Initializing configuration ->
            ( Solving { puzzle = puzzle, configuration = configuration }, Cmd.none )

        Solving data ->
            if Puzzle.isSolved puzzle then
                ( Solved { data | puzzle = puzzle }, Cmd.none )

            else
                ( Solving { data | puzzle = puzzle }, Cmd.none )

        Solved data ->
            ( Solved { data | puzzle = puzzle }, Cmd.none )


view : Model -> Document Msg
view model =
    { title = "Best wishes for 2022"
    , body =
        [ viewControl model
        , viewPuzzle model
        ]
            |> List.map Html.toUnstyled
    }


viewControl : Model -> Html Msg
viewControl _ =
    Html.div [ Event.onClick Shuffle ] [ Html.button [] [ Html.text "shuffle" ] ]


viewPuzzle : Model -> Html Msg
viewPuzzle model =
    model
        |> puzzleOf
        |> Maybe.map (Puzzle.view <| configurationOf model)
        |> Maybe.withDefault (Html.div [] [])
        |> Html.map PuzzleMsg


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
