module Api.Messages exposing (Message(..))

import Server.WebSocket as WebSocket
import Api.Lib.RaspberryPi exposing (Event)
import Time exposing (Time)

type Message =
    Init 
    | InternalError String
    | Ws WebSocket.Msg
    | Raspi Event
    | UpdateColor Int Int Int (Maybe WebSocket.Id) -- h, s, v and an optional source of change
    | RainbowTick Time