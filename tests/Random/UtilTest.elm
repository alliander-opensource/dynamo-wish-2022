module Random.UtilTest exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Random
import Random.Util exposing (uniquePair)
import Test exposing (..)


suite : Test
suite =
    describe "Random module"
        [ describe "Util module"
            [ describe "uniquePair"
                [ fuzz int "never generate same elements" <|
                    \n ->
                        let
                            seed =
                                Random.initialSeed n

                            generator =
                                Random.int 0 100

                            ( ( a, b ), _ ) =
                                Random.step (uniquePair generator) seed
                        in
                        Expect.false "two different elements" <| a == b
                ]
            ]
        ]
