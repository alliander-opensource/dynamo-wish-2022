module Puzzle.SolveTest exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string, tuple)
import Json.Decode as Json
import Puzzle exposing (Cell(..))
import Puzzle.Solver as Solver
import Test exposing (..)


range : Fuzzer Int
range =
    Fuzz.intRange 2 5


suite : Test
suite =
    describe "Puzzle module"
        [ describe "Solver module"
            [ describe "solve"
                [ fuzz2 range range "solver can solve unshuffled puzzle" <|
                    \columns rows ->
                        let
                            configuration =
                                { columns = columns, rows = rows }

                            puzzle =
                                Puzzle.new configuration

                            plan =
                                Solver.solve puzzle
                        in
                        Expect.equal plan []
                , fuzz3 range range (Fuzz.intRange 0 (25 - 1)) "solver can solve puzzle with one slide" <|
                    \columns rows index ->
                        let
                            configuration =
                                { columns = columns, rows = rows }

                            cell =
                                Cell index

                            puzzle =
                                Puzzle.new configuration
                                    |> Puzzle.slide cell

                            plan =
                                Solver.solve puzzle
                        in
                        Expect.true "puzzle should be solved" <| Puzzle.isSolved <| List.foldl Puzzle.slide puzzle plan
                , fuzz3 range range (tuple ((Fuzz.intRange 0 (25 - 1)), (Fuzz.intRange 0 (25 - 1)))) "solver can solve puzzle with two slide" <|
                    \columns rows ( first, second ) ->
                        let
                            configuration =
                                { columns = columns, rows = rows }

                            puzzle =
                                Puzzle.new configuration
                                    |> Puzzle.slide (Cell first)
                                    |> Puzzle.slide (Cell second)

                            plan =
                                Solver.solve puzzle
                        in
                        Expect.true "puzzle should be solved" <| Puzzle.isSolved <| List.foldl Puzzle.slide puzzle plan
                ]
            ]
        ]
