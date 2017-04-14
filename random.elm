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
  { dieFace1 : Int
  , dieFace2 : Int
  }


-- UPDATE

type Msg = Roll
  | NewFace1 Int
  | NewFace2 Int

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Roll ->
      ( model, Random.generate NewFace1 (Random.int 1 6) )

    NewFace1 newFace ->
      ( {model | dieFace1 = newFace}, Random.generate NewFace2 (Random.int 1 6) )

    NewFace2 newFace ->
      ( {model | dieFace2 = newFace}, Cmd.none )


-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ img [ src ("https://wpclipart.com/recreation/games/dice/die_face_" ++ (toString model.dieFace1) ++ ".png") ] []
    , img [ src ("https://wpclipart.com/recreation/games/dice/die_face_" ++ (toString model.dieFace2) ++ ".png") ] []
    , button [ onClick Roll ] [ text "Roll" ]
    ]


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


-- INIT

init : (Model, Cmd Msg)
init =
  ({dieFace1 = 1, dieFace2 = 1}, Cmd.none)