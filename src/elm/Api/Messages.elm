module Api.Messages exposing (
    Message(..)
    )

import Server.WebSocket as WebSocket

type Message =
    InternalError String
    | WebSocketMsg WebSocket.Msg
    | UpdateColor Int Int Int (Maybe WebSocket.Id) -- h, s, v and an optional source of change