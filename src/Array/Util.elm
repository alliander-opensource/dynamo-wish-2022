module Array.Util exposing (all, find, zip)

import Array exposing (Array)
import List.Util as Util


zip : Array x -> Array y -> Array ( x, y )
zip xs ys =
    let
        us =
            xs
                |> Array.toList

        vs =
            ys
                |> Array.toList
    in
    Util.zip us vs
        |> Array.fromList


all : (a -> Bool) -> Array a -> Bool
all predicate xs =
    xs
        |> Array.toList
        |> List.all predicate


find : a -> Array a -> Maybe Int
find needle haystack =
    haystack
        |> Array.indexedMap Tuple.pair
        |> Array.filter (Tuple.second >> (==) needle)
        |> Array.map Tuple.first
        |> Array.get 0
