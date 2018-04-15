module Api.Main exposing (main)

import Platform exposing (Program)
import Server.WebSocket as WebSocket

import Api.Model exposing (..)
import Api.Messages exposing (Message(..))
import Api.Update exposing (update)

routeMessage : Result WebSocket.Error WebSocket.Msg -> Message
routeMessage incoming =
    case incoming of
        Err (WebSocket.Error reason) -> InternalError reason
        Ok msg -> WebSocketMsg msg

subscriptions : a -> Sub Message
subscriptions model = WebSocket.listen routeMessage

main : Program Never Model Message
main = 
    Platform.program
        { init = (initial, Cmd.none)
        , update = update
        , subscriptions = subscriptions
        }