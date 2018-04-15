module Ui.Update exposing (update)

import Debug exposing (log)
import WebSocket exposing (send)
import Json.Decode exposing (decodeString)

import Ui.Config exposing (config)
import Ui.Model exposing (..)
import Ui.Actions exposing (..)


update : Action -> Model -> (Model, Cmd Action)
update action model =
    case action of
        SetHue hue ->
            ({ model | h = hue }, send config.websocketUrl (toString hue))

        SetValue value ->
            ({ model | v = value }, Cmd.none)
            
        Resize size ->
            ( { model | windowSize = size }, Cmd.none )
   
        DragStart _ ->
            ( { model | dragging = True }, Cmd.none )

        DragAt (originX, originY) (x, y) ->
            let angle = atan2 (x-originX) (y-originY) / (degrees 1) |> round
                newHue = 180 - angle
            in model |> update (SetHue newHue)

        DragEnd _ ->
            ( { model | dragging = False }, Cmd.none )

        SocketMessage stringMessage ->
            case decodeString socketMessageDecoder stringMessage of
                Ok (Color h s v) -> ({model | h = h, s = s, v = v}, Cmd.none)
                Err err -> log err (model, Cmd.none)
    