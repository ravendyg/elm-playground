module Routing exposing (..)

import Navigation exposing (Location)
import Models exposing (PlayerId, Route(..))
import UrlParser exposing (..)
import Html exposing (Attribute)
import Html.Events exposing (onWithOptions)
import Json.Decode as Decode


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map PlayersRoute top
        , map PlayerRoute (s "player" </> string)
        , map PlayersRoute (s "players")
        ]


parseLocation : Location -> Route
parseLocation location =
    -- though couldn't setup webpack dev server to always redirect to '/'
    case (parsePath matchers location) of
        Just route ->
            route

        Nothing ->
            NotFoundRoute


playersPath : String
playersPath =
    "/players"


playerPath : PlayerId -> String
playerPath id =
    "/player/" ++ id


onLinkClick : msg -> Attribute msg
onLinkClick message =
    let
        options =
            { stopPropagation = False
            , preventDefault = True
            }
    in
        onWithOptions "click" options (Decode.succeed message)
