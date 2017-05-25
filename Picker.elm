module Picker exposing (viewPicker)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)

viewPicker : List (String, msg, String) -> Html msg
viewPicker options =
  fieldset [] (List.map radiobutton options)

radiobutton : (String, msg, String) -> Html msg
radiobutton (name, msg, selected_) =
  Debug.log (toString (name == selected_))
  label []
    [ input [ type_ "radio", selected False, onClick msg ] []
    , text name
    ]