module Array.UtilTest exposing (..)

import Array
import Array.Util exposing (all, zip, find)
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)


suite : Test
suite =
    describe "Array module"
        [ describe "Util module"
            [ describe "zip"
                [ test "pairs two arrays" <|
                    \_ ->
                        let
                            left =
                                [ 1, 2, 3 ]
                                    |> Array.fromList

                            right =
                                [ 'a', 'b', 'c' ]
                                    |> Array.fromList

                            actual =
                                zip left right

                            expected =
                                [ ( 1, 'a' ), ( 2, 'b' ), ( 3, 'c' ) ]
                                    |> Array.fromList
                        in
                        Expect.equal actual expected
                , test "pairs up to the shortes array" <|
                    \_ ->
                        let
                            left =
                                [ 1, 2, 3 ]
                                    |> Array.fromList

                            right =
                                [ 'a', 'b' ]
                                    |> Array.fromList

                            actual =
                                zip left right

                            expected =
                                [ ( 1, 'a' ), ( 2, 'b' ) ]
                                    |> Array.fromList
                        in
                        Expect.equal actual expected
                ]
            , describe "all"
                [ test "all should pass when predicate it true for all" <|
                    \_ ->
                        let
                            predicate n =
                                n > 0

                            actual =
                                [ 1, 2, 3 ]
                                    |> Array.fromList
                        in
                        Expect.true "all elements should adhere to predicate" <| all predicate actual
                ]
            , describe "find"
                [ test "find should return the index of element when it is present" <|
                    \_ ->
                        let
                            haystack =
                                [ 'a', 'b', 'c' ]
                                    |> Array.fromList

                            needle = 'b'

                        in
                        Expect.equal (Just 1) <| find needle haystack
                ]
            ]
        ]
