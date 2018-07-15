module Main exposing (..)

import Button
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


type alias NewMember =
    { name : String
    , age : Int
    }


type Msg
    = UpdateTable Table
    | UpdateName (Input String)
    | UpdateAge (Input Int)
    | Submit NewMember


init : ( Model, Cmd Msg )
init =
    ( { table = Table.init
      , data = [ 1, 2, 3, 4 ]
      , name = Input.init Ok ""
      , age = Input.init String.toInt (toString 0)
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

        Submit newMember ->
            init


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
        , Button.submit
            { handleUpdate = Submit
            , text = "Submit"
            }
            (Input.get2 NewMember model.name model.age)
        ]
