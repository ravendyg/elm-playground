import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)

main =
  Html.beginnerProgram
    { model = model
    , view = view
    , update = update
    }


-- MODEL

type alias Model =
  { notifications : Bool
  , autoplay : Bool
  , location : Bool
  }

model : Model
model =
  { notifications = False
  , autoplay = False
  , location = False
  }

-- UPDATE

type Msg =
  ToggleNotifications
  | ToggleAutoplay
  | ToggleLocation

update : Msg -> Model -> Model
update msg model =
  case msg of
    ToggleNotifications ->
      {model | notifications = not model.notifications}

    ToggleAutoplay ->
      {model | autoplay = not model.autoplay}

    ToggleLocation ->
      {model | location = not model.location}


-- VIEW

view : Model -> Html Msg
view model =
  fieldset []
    [ checkbox ToggleNotifications "Email notifications"
    , checkbox ToggleAutoplay "Video autoplay"
    , checkbox ToggleLocation "Use location"
    ]


checkbox : msg -> String -> Html msg
checkbox msg name =
  label []
    [ input [ type_ "checkbox", onClick msg] []
    , text name
    ]