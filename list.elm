import Html exposing (Html, Attribute, div, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)


main =
  Html.beginnerProgram { model = model, view = view, update = update }


-- MODEL

type Lst a = Empty | Node a (Lst a)

type alias Model =
  { content : Lst String
  }

model : Model
model =
  { content = Node "qwe" (Node "xxv" Empty) }


-- UPDATE

type Msg
  = Change String

update : Msg -> Model -> Model
update msg model =
  case msg of
    Change newContent ->
      { model | content = Node newContent model.content}


-- VIEW

view : Model -> Html Msg
view model =
  div []
    -- (List.concat [ -- input [ placeholder "Text to add", onInput Change ] []
        (List.map renderItem [(Node "xxv" Empty)])
    -- ])

renderItem : Lst String -> Html Msg
renderItem node =
    case node of
        Empty ->
            div [] [ text "end" ]
        Node st rest ->
            div [] [ text st ]