import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode

main =
  Html.program
  {
    init = init "cats",
    view = view, update = update,
    subscriptions = subscriptions
  }


-- MODEL

type alias Model =
  { topic : String
  , gifUrl : String
  , error : String
  }



-- INIT

init : String -> ( Model, Cmd Msg )
init topic =
  (Model topic "waiting.gif" "", Cmd.none)


-- UPDATE

type Msg = MorePlease
  | NewTopic String
  | NewGif (Result Http.Error String)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    MorePlease ->
      (model, getRandomGif model.topic)

    NewTopic value ->
        if value == "" then
          ({model | error = "Bad topic"}, Cmd.none)
        else
          ({model | topic = value, error = ""}, Cmd.none)


    NewGif (Ok newUrl) ->
        ({model | gifUrl = newUrl, error = ""}, Cmd.none)

    NewGif (Err _) ->
      ({model | error = "Http error"}, Cmd.none)


-- VIEW
view : Model -> Html Msg
view model =
  div []
    -- [ h2 [] [text model.topic]
    [ input [onInput NewTopic, value model.topic] []
    , select [onInput NewTopic] (List.map createOption ["cats", "smth"])
    -- , img [src model.gifUrl] []
    , p [] [text model.gifUrl]
    , button [onClick MorePlease] [text "More Please!"]
    , p [] [Html.text model.error]
    ]


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


-- FUNCTIONS

getRandomGif : String -> Cmd Msg
getRandomGif topic =
  let
    url = "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ topic
    request = Http.get url decodeGifUrl
  in
    Http.send NewGif request

decodeGifUrl : Json.Decode.Decoder String
decodeGifUrl =
  Json.Decode.at ["data", "image_url"] Json.Decode.string


createOption : String -> Html Msg
createOption value =
  Html.option [] [text value]