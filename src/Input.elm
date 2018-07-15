module Input exposing (Input, get, get2, init, view)

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
        , render = \send -> render send options input
        }


render : (Msg -> msg) -> Options msg a -> Input a -> Html msg
render send options (Input model) =
    div []
        [ label [] [ text options.label ]
        , input
            [ value model.value
            , onInput InputValue
                |> Html.Attributes.map send
            ]
            []
        , case model.validate model.value of
            Ok _ ->
                text ""

            Err error ->
                div [] [ text error ]
        ]


get : (a -> b) -> Input a -> Maybe b
get f (Input model) =
    Result.map f
        (model.validate model.value)
        |> Result.toMaybe


get2 : (a -> b -> c) -> Input a -> Input b -> Maybe c
get2 f (Input model1) (Input model2) =
    Result.map2 f
        (model1.validate model1.value)
        (model2.validate model2.value)
        |> Result.toMaybe
