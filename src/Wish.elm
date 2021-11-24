module Wish exposing (..)

import Browser exposing (Document)
import Css
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attributes
import Puzzle exposing (Puzzle)


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


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        PuzzleMsg msg ->
            let
                puzzle =
                    Puzzle.update msg model.puzzle
            in
            ( { model | puzzle = puzzle }, Cmd.none )


view : Model -> Document Msg
view model =
    { title = "Best wishes for 2022"
    , body =
        [ Puzzle.view model.configuration model.puzzle
            |> Html.map PuzzleMsg
            |> Html.toUnstyled
        ]
    }


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
