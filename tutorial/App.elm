module App exposing (..)

import Html exposing (Html, div, text, button, program)
import Html.Events exposing (onClick)
import Mouse
import Keyboard
import Random


-- MODEL


type alias Model =
    { text : String
    , flag : Bool
    , val : Int
    , x : Int
    , y : Int
    , ran : Int
    }


init : ( Model, Cmd Msg )
init =
    ( { text = "Hello"
      , flag = False
      , val = 0
      , x = 0
      , y = 0
      , ran = 0
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
    | KeyMsg Keyboard.KeyCode
    | MouseMsg Mouse.Position
    | MouseClick Mouse.Position
    | OnResult Int



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
            , div []
                [ text <| "Coordinates: " ++ (toString model.x) ++ ", " ++ (toString model.y) ]
            , div []
                [ text <| "Random: " ++ (toString model.ran) ]
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

        KeyMsg code ->
            parseKeyCode model code

        MouseMsg position ->
            let
                { x, y } =
                    position
            in
                ( { model | x = x, y = y }, Cmd.none )

        MouseClick position ->
            ( model, Random.generate OnResult (Random.int 0 10) )

        OnResult ran ->
            ( { model | ran = ran }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    if model.val < 10 then
        Sub.batch
            [ Keyboard.ups KeyMsg
            , Mouse.moves MouseMsg
            , Mouse.clicks MouseClick
            ]
    else
        Sub.batch
            [ Keyboard.ups KeyMsg
            , Mouse.clicks MouseClick
            ]



-- MAIN


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


parseKeyCode : Model -> Keyboard.KeyCode -> ( Model, Cmd Msg )
parseKeyCode model code =
    case code of
        107 ->
            ( { model | val = model.val + 1 }, Cmd.none )

        109 ->
            ( { model | val = model.val - 1 }, Cmd.none )

        _ ->
            ( model, Cmd.none )
