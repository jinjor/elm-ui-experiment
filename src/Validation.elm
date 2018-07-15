module Validation exposing (..)


type alias Validation a =
    String -> Result String a


validate : Validation String
validate =
    String.trim >> Ok


custom : (a -> Result String b) -> Validation a -> Validation b
custom f v =
    \s -> Result.andThen f (v s)


number : Validation String -> Validation Float
number =
    custom <|
        \s ->
            case String.toFloat s of
                Ok n ->
                    Ok n

                Err _ ->
                    Err "should not be a number"


integer : Validation String -> Validation Int
integer =
    custom <|
        \s ->
            case String.toInt s of
                Ok n ->
                    Ok n

                Err _ ->
                    Err "should not be an integer"


nonEmpty : Validation String -> Validation String
nonEmpty =
    custom <|
        \s ->
            if s == "" then
                Err "should not be empty"

            else
                Ok s


maxLength : Int -> Validation String -> Validation String
maxLength threshold =
    custom <|
        \s ->
            if String.length s > threshold then
                Err ("should be " ++ toString threshold ++ " or less charactors")

            else
                Ok s


min : comparable -> Validation comparable -> Validation comparable
min threshold =
    custom <|
        \n ->
            if n >= threshold then
                Ok n

            else
                Err ("should be " ++ toString n ++ " or more")


max : comparable -> Validation comparable -> Validation comparable
max threshold =
    custom <|
        \n ->
            if n <= threshold then
                Ok n

            else
                Err ("should be " ++ toString n ++ " or less")
