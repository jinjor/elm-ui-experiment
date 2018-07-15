module UI exposing (..)

import Html exposing (..)


type alias Options model local msg =
    { handleUpdate : model -> msg
    , model : model
    , update : local -> model -> model
    , render : (local -> msg) -> Html msg
    }


view : Options model local msg -> Html msg
view options =
    options.render
        (\localMsg ->
            options.handleUpdate (options.update localMsg options.model)
        )
