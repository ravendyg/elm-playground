import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Random

main =
  Html.program
    {
      init = init,
      view = view, update = update,
      subscriptions = subscriptions
  }

-- MODEL

type alias Model =
  { dieFace : Int
  }


-- UPDATE

type Msg = Roll
  | NewFace Int

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Roll ->
      ( model, Random.generate NewFace (Random.int 1 6) )

    NewFace newFace ->
      ( Model newFace, Cmd.none )


-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ -- h1 [] [ text (toString model.dieFace) ]
      img [ src ("https://wpclipart.com/recreation/games/dice/die_face_" ++ (toString model.dieFace) ++ ".png") ] []
    , button [ onClick Roll ] [ text "Roll" ]
    ]


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


-- INIT

init : (Model, Cmd Msg)
init =
  (Model 1, Cmd.none)