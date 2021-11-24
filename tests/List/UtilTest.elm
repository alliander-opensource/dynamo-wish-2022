module List.UtilTest exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import List.Util exposing (zip)
import Test exposing (..)


suite : Test
suite =
    describe "List module"
        [ describe "Util module"
            [ describe "zip"
                [ test "pairs two lists" <|
                    \_ ->
                        let
                            left =
                                [ 1, 2, 3 ]

                            right =
                                [ 'a', 'b', 'c' ]

                            actual =
                                zip left right

                            expected =
                                [ ( 1, 'a' ), ( 2, 'b' ), ( 3, 'c' ) ]
                        in
                        Expect.equal actual expected
                , test "pairs up to the shortes list" <|
                    \_ ->
                        let
                            left =
                                [ 1, 2, 3 ]

                            right =
                                [ 'a', 'b' ]

                            actual =
                                zip left right

                            expected =
                                [ ( 1, 'a' ), ( 2, 'b' ) ]
                        in
                        Expect.equal actual expected
                ]
            ]
        ]
