module Puzzle.Solver exposing (solve)

import Maybe.Util exposing (orElse)
import Puzzle exposing (Cell, Puzzle)


solve : Puzzle -> List Cell
solve =
    aStar


aStar : Puzzle -> List Cell
aStar =
    aStarAtDepth 0


aStarAtDepth : Int -> Puzzle -> List Cell
aStarAtDepth current puzzle =
    atDepth current puzzle
        |> orElse (\_ -> aStarAtDepth (current + 1) puzzle)


atDepth : Int -> Puzzle -> Maybe (List Cell)
atDepth =
    solvePlanOfLength [ [] ]


solvePlanOfLength : List (List Cell) -> Int -> Puzzle -> Maybe (List Cell)
solvePlanOfLength candidates maximum puzzle =
    case candidates of
        [] ->
            Nothing

        plan :: rest ->
            if List.length plan < maximum then
                let
                    current =
                        execute plan puzzle

                    promising =
                        current
                            |> Puzzle.slideable
                            |> List.map (\cell -> cell :: plan)

                    cs =
                        List.concat [ promising, rest ]
                in
                solvePlanOfLength cs maximum puzzle

            else
            -- plan has correct length
            if
                Puzzle.isSolved <| execute plan puzzle
            then
                plan
                    |> List.reverse
                    |> Just

            else
                solvePlanOfLength rest maximum puzzle


{-| execute a plan on a puzzle.

Since plans grow by cons-ing a new step to an existing plan, we need to perform the steps from the end of the plan first. That is why the `List.foldr` is used.

-}
execute : List Cell -> Puzzle -> Puzzle
execute plan puzzle =
    List.foldr Puzzle.slide puzzle plan
