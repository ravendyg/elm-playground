import Html exposing (..)
import Html.Attributes exposing (..)

import Picker

main =
  Html.beginnerProgram
    { model = model
    , view = view
    , update = update
    }


-- MODEL

type FontSize = Small | Medium | Large

type alias Model =
  { fontSize : FontSize
  , content : String
  }

model : Model
model =
  { fontSize = Medium
  , content = "Example content"
  }

-- UPDATE

type Msg =
  SwitchTo FontSize

update : Msg -> Model -> Model
update msg model =
  case msg of
    SwitchTo fontSize ->
      {model | fontSize = fontSize}


-- VIEW

view : Model -> Html Msg
view model =
  let
    size = getSize model
  in
    div []
      [ p [ Html.Attributes.style [("fontSize", size)] ] [ text model.content ]
      , Picker.viewPicker
          [ ("Small", SwitchTo Small, getFontSizeName model.fontSize)
          , ("Medium", SwitchTo Medium, getFontSizeName model.fontSize)
          , ("Large", SwitchTo Large, getFontSizeName model.fontSize)
          ]
      ]


getSize : Model -> String
getSize model =
  case model.fontSize of
    Small  -> "10px"
    Medium -> "15px"
    Large  -> "20px"

getFontSizeName : FontSize -> String
getFontSizeName size =
  "Small"