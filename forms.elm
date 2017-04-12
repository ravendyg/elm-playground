import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Regex exposing (..)


main =
  Html.beginnerProgram { model = model, view = view, update = update }


-- MODEL

type alias Model =
  { name : String
  , password : String
  , passwordAgain : String
  , submited : Bool
  }


model : Model
model =
  Model "" "" "" False


-- UPDATE

type Msg
    = Name String
    | Password String
    | PasswordAgain String
    | Submit


update : Msg -> Model -> Model
update msg model =
  case msg of
    Name name ->
      { model | name = name }

    Password password ->
      { model | password = password }

    PasswordAgain password ->
      { model | passwordAgain = password }

    Submit ->
      { model | submited = True }


-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ input [ type_ "text", placeholder "Name", onInput Name ] []
    , input [ type_ "password", placeholder "Password", onInput Password ] []
    , input [ type_ "password", placeholder "Re-enter Password", onInput PasswordAgain ] []
    , button [ onClick Submit ] [ text "Submit" ]
    , drawMessage model
    ]


drawMessage : Model -> Html msg
drawMessage model =
  if model.submited then
    viewValidation model
  else
    Html.text ""

viewValidation : Model -> Html msg
viewValidation model =
  let
    (color, message) =
      if String.length model.name == 0 then
        ("red", "Name is empty!")
      else if (Regex.contains (Regex.regex "[0-9]") model.password) == False then
        ("red", "Password should include digits")
      else if String.length model.password < 3 then
        ("red", "Password is to short!")
      else if model.password /= model.passwordAgain then
        ("red", "Passwords do not match!")
      else
        ("green", "OK")
  in
    div [ style [("color", color)] ] [ text message ]