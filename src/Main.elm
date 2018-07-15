module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
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
    , name : Input String
    , age : Input Int
    }


type Msg
    = UpdateTable Table
    | UpdateName (Input String)
    | UpdateAge (Input Int)


init : ( Model, Cmd Msg )
init =
    ( { table = Table.init
      , data = [ 1, 2, 3, 4 ]
      , name = Input.init Ok "Bob"
      , age = Input.init String.toInt (toString 20)
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

        UpdateName name ->
            ( { model | name = name }
            , Cmd.none
            )

        UpdateAge age ->
            ( { model | age = age }
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
            { handleUpdate = UpdateName
            , label = "Name"
            }
            model.name
        , Input.view
            { handleUpdate = UpdateAge
            , label = "Age"
            }
            model.age
        , button
            [ disabled (Input.get2 (\_ _ -> ()) model.name model.age == Nothing)
            ]
            [ text "Send" ]
        ]
