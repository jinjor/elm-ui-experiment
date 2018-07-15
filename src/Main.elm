module Main exposing (..)

import Html exposing (..)
import Input exposing (Input)
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
    , input : Input Int
    }


type Msg
    = UpdateTable Table
    | UpdateInput (Input Int)


init : ( Model, Cmd Msg )
init =
    ( { table = Table.init
      , data = [ 1, 2, 3, 4 ]
      , input = Input.init String.toInt (toString 0)
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateTable table ->
            ( { model | table = table }
            , Cmd.none
            )

        UpdateInput input ->
            ( { model | input = input }
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
        , Input.view
            { handleUpdate = UpdateInput
            , label = "Input"
            }
            model.input
        ]
