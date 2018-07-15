module Main exposing (..)

import Html exposing (..)
import Table exposing (Table)


main : Program Never Model Msg
main =
    program
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }


type alias Model =
    { table : Table
    , data : List Int
    }


type Msg
    = UpdateTable Table


init : ( Model, Cmd Msg )
init =
    ( Model Table.init [ 1, 2, 3, 4 ]
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateTable table ->
            ( { model | table = table }
            , Cmd.none
            )


view : Model -> Html Msg
view model =
    div
        []
        [ h1 [] [ text "example" ]
        , Table.view
            { handleUpdate = UpdateTable
            , compare = compare
            , viewItem = \item -> text (toString item)
            }
            model.table
            model.data
        ]
