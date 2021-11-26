module Puzzle.ConfigurationTest exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Json.Decode as Json
import Puzzle.Configuration as Configuration
import Test exposing (..)


suite : Test
suite =
    describe "Puzzle module"
        [ describe "Configuration module"
            [ describe "decode"
                [ test "JSON can be decoded" <|
                    \_ ->
                        let
                            input =
                                """{
                                    "puzzle": {"columns": 4, "rows": 4},
                                    "cell": {"size": 50},
                                    "shuffle": {"minimum": 20, "maximum": 50}
                                    }"""

                            actual =
                                Json.decodeString Configuration.decode input

                            expected =
                                Ok
                                    { puzzle = { columns = 4, rows = 4 }
                                    , cell = { size = 50 }
                                    , shuffle = { minimum = 20, maximum = 50 }
                                    }
                        in
                        Expect.equal actual expected
                ]
            ]
        ]
