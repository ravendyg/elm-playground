import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)

-- import Picker

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
    -- div []
    --   [ p [ Html.Attributes.style [("fontSize", size)] ] [ text model.content ]
    --   , Picker.viewPicker
    --       [ ("Small", SwitchTo Small, getFontSizeName model.fontSize)
    --       , ("Medium", SwitchTo Medium, getFontSizeName model.fontSize)
    --       , ("Large", SwitchTo Large, getFontSizeName model.fontSize)
    --       ]
    --   ]
        div []
      [ p [ Html.Attributes.style [("fontSize", size)] ] [ text model.content ]
      , radiobutton (Small, model.fontSize, SwitchTo Small)
      , radiobutton (Medium, model.fontSize, SwitchTo Medium)
      , radiobutton (Large, model.fontSize, SwitchTo Large)
      ]


getSize : Model -> String
getSize model =
  case model.fontSize of
    Small  -> "10px"
    Medium -> "15px"
    Large  -> "20px"

getFontSizeName : FontSize -> String
getFontSizeName size =
  case model.fontSize of
    Small  -> "Small"
    Medium -> "Medium"
    Large  -> "Large"


radiobutton : (FontSize, FontSize, msg) -> Html msg
radiobutton (self, fontSize, msg) =
  let
    selected_ = self == fontSize
  in
    label []
      [ input [ type_ "radio", name "font-size", checked selected_, onClick msg ] []
      , text (toString self)
      ]