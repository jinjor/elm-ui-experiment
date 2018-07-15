module Validation exposing (..)


type alias Validation a =
    String -> Result String a


validate : Validation String
validate =
    String.trim >> Ok


custom : (a -> Result String b) -> Validation a -> Validation b
custom f v =
    \s -> Result.andThen f (v s)


decode : (String -> Maybe a) -> String -> Validation String -> Validation a
decode decodeString errorMessage =
    custom <|
        \s ->
            case decodeString s of
                Just a ->
                    Ok a

                Nothing ->
                    Err errorMessage


checkIf : (a -> Bool) -> String -> Validation a -> Validation a
checkIf isValid errorMessage =
    custom <|
        \a ->
            if isValid a then
                Ok a

            else
                Err errorMessage


number : Validation String -> Validation Float
number =
    decode
        (String.toFloat >> Result.toMaybe)
        "should be a number"


integer : Validation String -> Validation Int
integer =
    decode
        (String.toInt >> Result.toMaybe)
        "should be an integer"


nonEmpty : Validation String -> Validation String
nonEmpty =
    checkIf
        (\s -> s /= "")
        "should not be empty"


maxLength : Int -> Validation String -> Validation String
maxLength threshold =
    checkIf
        (\s -> String.length s <= threshold)
        ("should be " ++ toString threshold ++ " or less characters")


min : comparable -> Validation comparable -> Validation comparable
min threshold =
    checkIf
        (\n -> n >= threshold)
        ("should be " ++ toString threshold ++ " or more")


max : comparable -> Validation comparable -> Validation comparable
max threshold =
    checkIf
        (\n -> n <= threshold)
        ("should be " ++ toString threshold ++ " or less")


optional : Validation a -> Validation String -> Validation (Maybe a)
optional v =
    custom <|
        \s ->
            if String.trim s == "" then
                Result.map Just (v s)

            else
                Ok Nothing
