module Input exposing (Input, init, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import UI exposing (..)


type alias Model a =
    { value : String
    , validate : String -> Result String a
    }


type Msg
    = InputValue String


type Input a
    = Input (Model a)


init : (String -> Result String a) -> String -> Input a
init validate value =
    Input
        { validate = validate
        , value = value
        }


update : Msg -> Input a -> Input a
update msg (Input model) =
    Input <|
        case msg of
            InputValue value ->
                { model
                    | value = value
                }


type alias Options msg a =
    { handleUpdate : Input a -> msg
    , label : String
    }


view : Options msg a -> Input a -> Html msg
view options input =
    UI.view
        { handleUpdate = options.handleUpdate
        , model = input
        , update = update
        , render =
            \send ->
                render
                    send
                    options
                    input
        }


render : (Msg -> msg) -> Options msg a -> Input a -> Html msg
render send options (Input model) =
    div []
        [ label [] [ text options.label ]
        , input
            [ value model.value
            , onInput (InputValue >> send)
            ]
            []
        , case model.validate model.value of
            Ok _ ->
                text ""

            Err error ->
                div [] [ text error ]
        ]
