module Picker exposing (viewPicker)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)


viewPicker : List (String, String, msg) -> Html msg
viewPicker options =
  fieldset [] (List.map radiobutton options)


radiobutton : (String, String, msg) -> Html msg
radiobutton (self, fontSize, msg) =
  let
    selected_ = self == fontSize
  in
    label []
      [ input [ type_ "radio", name "font-size", checked selected_, onClick msg ] []
      , text (toString self)
      ]