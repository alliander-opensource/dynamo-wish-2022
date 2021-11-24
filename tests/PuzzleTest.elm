module PuzzleTest exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Puzzle exposing (Cell(..), slide)
import Test exposing (..)


range : Fuzzer Int
range =
    Fuzz.intRange 2 5


suite : Test
suite =
    describe "Puzzle module"
        [ describe "isSolved"
            [ fuzz2 range range "a new puzzle is solved" <|
                \columns rows ->
                    let
                        puzzle =
                            Puzzle.new columns rows
                    in
                    Expect.true "puzzle should be solved" <| Puzzle.isSolved puzzle
            , fuzz3 range range (Fuzz.intRange 0 (25 - 1)) "when a cell is slided twice puzzle should be solved" <|
                \columns rows index ->
                    let
                        cell =
                            Cell index

                        puzzle =
                            Puzzle.new columns rows
                                |> slide cell
                                |> slide cell
                    in
                    Expect.true "puzzle should be solved" <| Puzzle.isSolved puzzle
            ]
        ]
