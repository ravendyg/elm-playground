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
    angleSec =
      -- turns (Time.inMinutes model)
      getSecAngle model

    handSecX =
      toString (50 + 40 * cos angleSec)

    handSecY =
      toString (50 + 40 * sin angleSec)

    minutes = getMinutes model
    angleMin =
      turns (Time.inHours model)

    handMinX =
      toString (40 + 40 * cos angleMin)

    handMinY =
      toString (40 + 40 * sin angleMin)

  in
    -- Debug.log (toString (Time.inMinutes model))
    Debug.log (toString (angleSec))
    -- Debug.log (toString (cos (Time.inMinutes model)))
    -- Debug.log (toString (cos (toFloat (ceiling (Time.inMinutes model)))))
    -- Debug.log (toString (turns (Time.inMinutes model) / 60))
    -- Debug.log (toString (Time.inMinutes model))
    -- Debug.log (toString (ceiling (Time.inMinutes model)))
    -- Debug.log (toString minutes)
    svg [ viewBox "0 0 100 100", width "300px" ]
      [ circle [ cx "50", cy "50", r "45", fill "#0B79CE" ] []
      , line [ x1 "50", y1 "50", x2 handSecX, y2 handSecY, stroke "#023963" ] []
      -- , line [ x1 "50", y1 "50", x2 handMinX, y2 handMinY, stroke "#523963" ] []
      ]


getSeconds : Time -> Int
getSeconds tsp =
  rem (ceiling (Time.inSeconds tsp)) 60

getSecAngle : Time -> Float
getSecAngle tsp =
  (toFloat (getSeconds tsp)) / 60 * 2 * pi - pi / 2

getMinutes : Time -> Int
getMinutes tsp =
  rem (ceiling (Time.inMinutes tsp)) 60