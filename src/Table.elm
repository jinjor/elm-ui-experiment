module Table exposing (Table, init, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import UI exposing (..)


type alias Model =
    { order : SortOrder
    }


type SortOrder
    = Asc
    | Desc


type Msg
    = SwitchOrder


type Table
    = Table Model


init : Table
init =
    Table
        { order = Asc
        }


update : Msg -> Table -> Table
update msg (Table model) =
    Table <|
        case msg of
            SwitchOrder ->
                { model
                    | order =
                        case model.order of
                            Asc ->
                                Desc

                            Desc ->
                                Asc
                }


type alias Options msg a =
    { handleUpdate : Table -> msg
    , viewItem : a -> Html msg
    , compare : a -> a -> Order
    }


view : Options msg a -> Table -> List a -> Html msg
view options table data =
    UI.view
        { handleUpdate = options.handleUpdate
        , model = table
        , update = update
        , render =
            \send ->
                render
                    send
                    options
                    table
                    data
        }


render : (Msg -> msg) -> Options msg a -> Table -> List a -> Html msg
render send options (Table model) items =
    table []
        [ thead []
            [ hr
                [ onClick (send SwitchOrder)
                ]
                [ th [] [ text "Item" ] ]
            ]
        , tbody []
            (items
                |> List.sortWith
                    (\a b ->
                        case model.order of
                            Asc ->
                                options.compare a b

                            Desc ->
                                options.compare b a
                    )
                |> List.map
                    (\item ->
                        tr [] [ td [] [ options.viewItem item ] ]
                    )
            )
        ]
