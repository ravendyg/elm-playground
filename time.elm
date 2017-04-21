import Html exposing (..)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time exposing(Time, second)


main =
  Html.program
  { init = init
  , view = view
  , update = update
  , subscriptions = subscriptions
  }

-- MODEL

type alias Model = Time

init : (Model, Cmd Msg)
init =
  (0, Cmd.none)


-- UPDATE

type Msg =
  Tick Time

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Tick newTime ->
      (newTime, Cmd.none)


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

  in
    svg [ viewBox "0 0 100 100", width "300px" ]
      [ circle [ cx "50", cy "50", r "45", fill "#0B79CE" ] []
      , line [ x1 "50", y1 "50", x2 handSecX, y2 handSecY, stroke "#023963" ] []
      , line [ x1 "50", y1 "50", x2 handMinX, y2 handMinY, stroke "#523963" ] []
      , line [ x1 "50", y1 "50", x2 handHouX, y2 handHouY, stroke "#029963" ] []
      ]


getAngle : Float -> Float
getAngle units =
  units / 60 * 2 * pi - pi / 2


getTspInSeconds : Time -> Int
getTspInSeconds tsp =
  round (Time.inSeconds tsp)

getSeconds : Time -> Float
getSeconds tsp =
  toFloat (rem (getTspInSeconds tsp) 60)

getMinutes : Time -> Float
getMinutes tsp =
  let
    sec = (getTspInSeconds tsp)
    min = (toFloat sec) / 60
    more = floor ((toFloat sec) / 60 / 60)
  in
    min - (toFloat more) * 60


getHours : Time -> Float
getHours tsp =
  let
    sec = (getTspInSeconds tsp)
    hou = (toFloat sec) / 60 / 60
    more = floor ((toFloat sec) / 60 / 60 / 24)
    diff = hou - ((toFloat more) * 24)
    di = if (diff + 7 >= 12) then diff - 12 else diff
  in
    -- +7 is a timezone hack, have found no way to get it programmaticaly
    (diff + 7) / 12 * 60