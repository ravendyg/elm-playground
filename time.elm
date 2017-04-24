import Html exposing (..)
import Html.Attributes exposing (..)
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

    ticks = List.range 0 11

  in
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

-- style : List (String, String) -> Html.Attribute msg
-- style =
--   VirtualDom.style

-- HELPERS

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

indentTime : Int -> String
indentTime input =
  let
    str = toString input
  in
    if String.length str == 1
    then "0" ++ str
    else str

getNumericTime : Time -> String
getNumericTime time =
  let
    tsp = (getTspInSeconds time)
    sec = rem tsp 60
    min = (tsp % (60 * 60)) // 60
    hou = (tsp % (60 * 60 * 24)) // (60 * 60) + 7
  in
    (indentTime hou) ++ ":" ++ (indentTime min) ++ ":" ++ (indentTime sec)

