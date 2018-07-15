module Button exposing (submit)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


type alias Options msg a =
    { handleUpdate : a -> msg
    , text : String
    }


submit : Options msg a -> Maybe a -> Html msg
submit options data =
    button
        (type_ "button"
            :: (case data of
                    Just a ->
                        [ onClick a
                            |> Html.Attributes.map options.handleUpdate
                        ]

                    Nothing ->
                        [ disabled True ]
               )
        )
        [ text options.text ]
