import Html exposing (..)
import Html.Attributes exposing (..)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time exposing(Time, second)


main =
  Html.programWithFlags
  { init = init
  , view = view
  , update = update
  , subscriptions = subscriptions
  }


-- MODEL

type alias Flags =
  { offset : Int
  , zone : String
  }

type alias Model =
  { time : Time
  , offset : Int
  , zone : String
  }

init : Flags -> (Model, Cmd Msg)
init flags =
  ({time = 0
  , offset = flags.offset
  , zone = flags.zone
  }, Cmd.none)


-- UPDATE

type Msg =
  Tick Time

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Tick newTime ->
      ({model | time = newTime}, Cmd.none)


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Time.every second Tick


-- VIEW

view : Model -> Html Msg
view model =
  let
    angleSec = getAngle (getSeconds model)
    angleMin = getAngle (getMinutes model)
    angleHou = getAngle (getHours model)

    handSecX = toString (50 + 40 * cos angleSec)
    handSecY = toString (50 + 40 * sin angleSec)

    handMinX = toString (50 + 35 * cos angleMin)
    handMinY = toString (50 + 35 * sin angleMin)

    handHouX = toString (50 + 30 * cos angleHou)
    handHouY = toString (50 + 30 * sin angleHou)

    ticks = List.range 0 11

  in
    case model.time /= 0 of
      True ->
        div [ Html.Attributes.style [("textAlign", "center")] ] [
          svg [ viewBox "0 0 100 100", Svg.Attributes.width "300px" ]
            (List.concat [
              [ circle [ cx "50", cy "50", r "45", fill "#0B79CE" ] []
              , line [ x1 "50", y1 "50", x2 handSecX, y2 handSecY, stroke "#023963" ] []
              , line [ x1 "50", y1 "50", x2 handMinX, y2 handMinY, stroke "#523963" ] []
              , line [ x1 "50", y1 "50", x2 handHouX, y2 handHouY, stroke "#029963" ] []
              ]
              , List.map getTick (List.range 0 59)
            ])
          , getDigitalClock (getNumericTime model)
        ]
      False -> div [ Html.Attributes.style [("textAlign", "center")] ] [
        Html.text "Loading..."
      ]

-- SVG
getTick : Int -> Svg Msg
getTick count =
  let
    out = 45
    tickLen = if rem count 5 == 0 then 5 else 2
    angl = (toFloat count) / 60 * 2 * pi
    x1_ = toString (50 + (out - tickLen) * cos angl)
    y1_ = toString (50 + (out - tickLen) * sin angl)
    x2_ = toString (50 + out * cos angl)
    y2_ = toString (50 + out * sin angl)
  in
    line [ x1 x1_, y1 y1_, x2 x2_, y2 y2_, stroke "#000000" ] []


-- HTML

getDigitalClock : String -> Html Msg
getDigitalClock val =
  div [ ] [
    Html.text val
  ]


-- HELPERS

getAngle : Float -> Float
getAngle units =
  units / 60 * 2 * pi - pi / 2


getTspInSeconds : Model -> Int
getTspInSeconds model =
  round (Time.inSeconds model.time)

getSeconds : Model -> Float
getSeconds model =
  toFloat (rem (getTspInSeconds model) 60)

getMinutes : Model -> Float
getMinutes model =
  let
    sec = (getTspInSeconds model)
    min = (toFloat sec) / 60
    more = floor ((toFloat sec) / 60 / 60)
  in
    min - (toFloat more) * 60


getHours : Model -> Float
getHours model =
  let
    sec = (getTspInSeconds model)
    hou = (toFloat sec) / 60 / 60
    more = floor ((toFloat sec) / 60 / 60 / 24)
    diff = hou - ((toFloat more) * 24)
    di = if (diff + (toFloat model.offset) >= 12) then diff - 12 else diff
  in
    (diff + (toFloat model.offset)) / 12 * 60

indentTime : Int -> String
indentTime input =
  let
    str = toString input
  in
    if String.length str == 1
    then "0" ++ str
    else str

getNumericTime : Model -> String
getNumericTime model =
  let
    tsp = (getTspInSeconds model)
    sec = rem tsp 60
    min = (tsp % (60 * 60)) // 60
    hou = (tsp % (60 * 60 * 24)) // (60 * 60) + model.offset
  in
    (indentTime hou) ++ ":" ++ (indentTime min) ++ ":" ++ (indentTime sec) ++ " (" ++ model.zone ++ ")"

