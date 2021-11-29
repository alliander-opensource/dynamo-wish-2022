module Wish exposing (..)

import Browser exposing (Document)
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attribute
import Html.Styled.Events as Event
import Json.Decode as Json
import Markdown
import Puzzle exposing (Puzzle)
import Puzzle.Configuration as Configuration
import Random
import Task


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
        input =
            """{
            "puzzle": {"columns": 6, "rows": 6},
            "image": {"src": "../docs/image/star.jpg", "width": 197, "height": 197},
            "shuffle": {"minimum": 20, "maximum": 50},
            "wish": {"message": "SGVsbG8sIFdvcmxkIQo="},
            "hints": {"indices": false}
            }"""
    in
    case Json.decodeString Configuration.decode input of
        Ok configuration ->
            let
                puzzle =
                    Puzzle.new configuration.puzzle
            in
            ( Initializing configuration, Task.perform Challenge <| Task.succeed puzzle )
            -- ( Initializing configuration, Random.generate Challenge <| Puzzle.shuffle configuration.shuffle puzzle )

        Err problem ->
            ( Failed problem, Cmd.none )


type Model
    = Failed Json.Error
    | Initializing Configuration.Main
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
    | ToggleIndicesHint Bool


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
                    configurationOf model
                        |> Maybe.map .shuffle
                        |> Maybe.map (\config -> Puzzle.shuffle config puzzle)
                        |> Maybe.map (Random.generate Challenge)

                cmd =
                    puzzleOf model
                        |> Maybe.andThen shuffleCmd
                        |> Maybe.withDefault Cmd.none
            in
            ( model, cmd )

        Challenge puzzle ->
            updatePuzzle puzzle model

        ToggleIndicesHint indices ->
            updateIndicesHint indices model


swap : (a -> b -> c) -> b -> a -> c
swap f b a =
    f a b


puzzleOf : Model -> Maybe Puzzle
puzzleOf model =
    case model of
        Failed _ ->
            Nothing

        Initializing _ ->
            Nothing

        Solving data ->
            Just data.puzzle

        Solved data ->
            Just data.puzzle


configurationOf : Model -> Maybe Configuration.Main
configurationOf model =
    case model of
        Failed _ ->
            Nothing

        Initializing configuration ->
            Just configuration

        Solving data ->
            Just data.configuration

        Solved data ->
            Just data.configuration


updatePuzzle : Puzzle -> Model -> ( Model, Cmd Msg )
updatePuzzle puzzle model =
    case model of
        Failed _ ->
            ( model, Cmd.none )

        Initializing configuration ->
            ( Solving { puzzle = puzzle, configuration = configuration }, Cmd.none )

        Solving data ->
            if Puzzle.isSolved puzzle then
                ( Solved { data | puzzle = puzzle }, Cmd.none )

            else
                ( Solving { data | puzzle = puzzle }, Cmd.none )

        Solved data ->
            ( Solved { data | puzzle = puzzle }, Cmd.none )


updateIndicesHint : Bool -> Model -> ( Model, Cmd Msg )
updateIndicesHint indices model =
    let
        updateData data =
            let
                old =
                    data.configuration.hints

                hints =
                    { old | indices = indices }

                oldConfiguration =
                    data.configuration

                configuration =
                    { oldConfiguration | hints = hints }
            in
            { data | configuration = configuration }
    in
    case model of
        Failed _ ->
            ( model, Cmd.none )

        Initializing configuration ->
            let
                old =
                    configuration.hints

                hints =
                    { old | indices = indices }
            in
            ( Initializing { configuration | hints = hints }, Cmd.none )

        Solving data ->
            ( Solving <| updateData data, Cmd.none )

        Solved data ->
            ( Solved <| updateData data, Cmd.none )


view : Model -> Document Msg
view model =
    { title = "Best wishes for 2022"
    , body =
        viewBody model
            |> List.map Html.toUnstyled
    }


viewBody : Model -> List (Html Msg)
viewBody model =
    case model of
        Failed problem ->
            [ viewFailure problem ]

        Initializing configuration ->
            [ viewInitializing configuration ]

        Solving data ->
            [ viewControl data, viewPuzzle data ]

        Solved data ->
            [ viewControl data, viewPuzzle data, viewWish data ]


viewFailure : Json.Error -> Html Msg
viewFailure problem =
    Html.div []
        [ Html.p [] [ Html.text "Problem decoding the configuration" ]
        , Html.pre [] [ Html.text <| Json.errorToString problem ]
        ]


viewInitializing : Configuration.Main -> Html Msg
viewInitializing _ =
    Html.div [] [ Html.p [] [ Html.text "Preparing wish" ] ]


viewControl : Data -> Html Msg
viewControl data =
    Html.div [] <|
        Html.button [ Event.onClick Shuffle ] [ Html.text "shuffle" ]
            :: viewHints data.configuration.hints


viewHints : Configuration.Hint -> List (Html Msg)
viewHints { indices } =
    [ Html.span []
        [ Html.label [ Attribute.for "indices" ] [ Html.text "show indices" ]
        , Html.input
            [ Event.onCheck ToggleIndicesHint
            , Attribute.type_ "checkbox"
            , Attribute.checked indices
            , Attribute.id "indices"
            ]
            []
        ]
    ]


viewPuzzle : Data -> Html Msg
viewPuzzle model =
    model
        |> .puzzle
        |> (Puzzle.view <| model.configuration)
        |> Html.map PuzzleMsg


viewWish : Data -> Html Msg
viewWish model =
    model
        |> .configuration
        |> .wish
        |> .message
        |> Markdown.toHtml []
        |> Html.fromUnstyled


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
