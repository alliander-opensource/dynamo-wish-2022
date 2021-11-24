module List.Util exposing (zip)


zip : List x -> List y -> List ( x, y )
zip =
    tailrec_zip []


tailrec_zip : List ( x, y ) -> List x -> List y -> List ( x, y )
tailrec_zip accumulator xs ys =
    case ( xs, ys ) of
        ( u :: us, v :: vs ) ->
            tailrec_zip (( u, v ) :: accumulator) us vs

        _ ->
            List.reverse accumulator
