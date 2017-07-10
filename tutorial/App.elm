module App exposing (..)

import Html exposing (Html, div, text, button, program)
import Html.Events exposing (onClick)


-- MODEL


type alias Model =
    { text : String
    , flag : Bool
    , val : Int
    }


init : ( Model, Cmd Msg )
init =
    ( { text = "Hello"
      , flag = False
      , val = 0
      }
    , Cmd.none
    )



-- MESSAGES


type Msg
    = NoOp
    | Smth String
    | Expand
    | Collapse
    | Increment Int



-- VIEW


view : Model -> Html Msg
view model =
    let
        header =
            if model.flag then
                div []
                    [ button [ onClick Collapse ] [ text " Collapse" ]
                    , text model.text
                    , button [ onClick <| Increment 2 ] [ text "+2" ]
                    ]
            else
                div []
                    [ button [ onClick Expand ] [ text "Expand" ] ]
    in
        div []
            [ header
            , text <| toString model.val
            ]



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Smth newText ->
            ( { model | text = newText }, Cmd.none )

        Expand ->
            ( { model | flag = True }, Cmd.none )

        Collapse ->
            ( { model | flag = False }, Cmd.none )

        Increment inc ->
            ( { model | val = model.val + inc }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- MAIN


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
