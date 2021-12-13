module Maybe.Util exposing (orElse)


orElse : (() -> a) -> Maybe a -> a
orElse fn option =
    case option of
        Just plan ->
            plan

        Nothing ->
            fn ()
