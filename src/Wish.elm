module Wish exposing (..)

import Browser exposing (Document)
import Css
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attributes
import Html.Styled.Events as Event
import Puzzle exposing (Puzzle)
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
        puzzle =
            Puzzle.new 4 4

        configuration =
            { cell = { size = 50 } }
    in
    ( { puzzle = puzzle, configuration = configuration }, Cmd.none )


type alias Model =
    { puzzle : Puzzle
    , configuration : Puzzle.Configuration
    }


type Msg
    = PuzzleMsg Puzzle.Msg
    | Shuffle
    | Challenge Puzzle


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        PuzzleMsg msg ->
            let
                puzzle =
                    Puzzle.update msg model.puzzle
            in
            ( { model | puzzle = puzzle }, Cmd.none )

        Shuffle ->
            ( model, Random.generate Challenge <| Puzzle.shuffle model.puzzle )

        Challenge puzzle ->
            ( { model | puzzle = puzzle }, Cmd.none )


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
    Puzzle.view model.configuration model.puzzle
        |> Html.map PuzzleMsg


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
