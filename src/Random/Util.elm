module Random.Util exposing (uniquePair)

import Random exposing (Generator)


uniquePair : Generator a -> Generator ( a, a )
uniquePair gen =
    let
        anyDifferentFrom : a -> Generator a
        anyDifferentFrom original =
            let
                takeIfDifferent candidate =
                    if original == candidate then
                        anyDifferentFrom original

                    else
                        Random.constant candidate
            in
            gen
                |> Random.andThen takeIfDifferent

        pairWithOther : a -> Generator ( a, a )
        pairWithOther original =
            anyDifferentFrom original
                |> Random.map (Tuple.pair original)
    in
    gen
        |> Random.andThen pairWithOther
