module Api.Subscriptions exposing (subscriptions)

import Server.WebSocket as WebSocket
import Api.Raspi as RaspberryPi
import Time exposing (..)

import Api.Model exposing (Model)
import Api.Messages exposing (Message(..))

-- Convert a (Result e a) to msg using given errFn and dataFn.
convertResult : (e -> msg) -> (a -> msg) -> Result e a -> msg
convertResult errFn dataFn result =
    case result of
        Err err -> errFn err
        Ok msg -> dataFn msg

convertWsError : WebSocket.Error -> Message 
convertWsError (WebSocket.Error reason) = InternalError reason

subscriptions : Model -> Sub Message
subscriptions model = 
    Sub.batch [
        WebSocket.listen <| convertResult convertWsError Ws,
        RaspberryPi.listen <| convertResult InternalError Raspi,

        -- Rainbow mode! increase hue every 20ms
        if model.rainbow then 
            Time.every (20 * millisecond) RainbowTick
        else
            Sub.none
    ]