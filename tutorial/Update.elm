module Update exposing (..)

import Msgs exposing (Msg(..))
import Models exposing (Model)
import Routing exposing (parseLocation)
import Navigation


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Msgs.OnFetchPlayers response ->
            ( { model | players = response }, Cmd.none )

        Msgs.OnLocationChange location ->
            let
                newRoute =
                    parseLocation location
            in
                ( { model | route = newRoute }, Cmd.none )

        Msgs.ChangeLocation path ->
            ( model, Navigation.newUrl path )
