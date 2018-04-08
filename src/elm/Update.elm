module Update exposing (update)

import Debug exposing (log)
import WebSocket exposing (send)
import Json.Decode exposing (decodeString)

import Config exposing (config)
import Model exposing (..)
import Actions exposing (..)


update : Action -> Model -> (Model, Cmd Action)
update action model =
    case action of
        HueSlider string -> 
            let newH = Result.withDefault 0 <| String.toInt string
            in model |> update (SetHue newH)

        LightSlider string ->
            let newV = Result.withDefault 0 <| String.toInt string
            in  model |> update (SetLight newV)

        SetHue hue ->
            ({ model | h = hue }, send (config.websocketUrl ++ "/hue") (toString hue))

        SetLight light ->
            ({ model | l = light }, send (config.websocketUrl ++ "/light") (toString light))
            
        Resize size ->
            ( { model | size = size }, Cmd.none )
   
        DragStart _ ->
            ( { model | dragging = True }, Cmd.none )

        DragAt (originX, originY) (x, y) ->
            let angle = atan2 (x-originX) (y-originY) / (degrees 1) |> round
                newHue = 180 - angle
            in model |> update (SetHue newHue)

        DragEnd _ ->
            ( { model | dragging = False }, Cmd.none )

        SocketMessage message -> 
            case decodeString hslDecoder message of
                Ok {h,s,l} -> ({model | h = h, s = s, l = l}, Cmd.none)
                Err err -> (model, Cmd.none)

    