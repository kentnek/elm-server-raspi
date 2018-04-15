module Api.Update exposing (update)

import Server.WebSocket as WebSocket

import Api.Model exposing (..)
import Api.Messages exposing (Message(..))

broadcast : String -> Maybe WebSocket.Id -> List WebSocket.Id -> Cmd msg
broadcast message sender clients =
    let targets = 
        case sender of
            Nothing -> clients
            Just s -> filterClients clients s 
    in Cmd.batch <| List.map (\c -> WebSocket.send message c) clients

update : Message -> Model -> (Model, Cmd msg)
update msg model =
    case msg of
        InternalError reason ->
            let _ = Debug.log "An internal Error Occoured" reason
            in (model, Cmd.none)

        WebSocketMsg (WebSocket.Connected id) -> (
            addClient model id, -- append new client
            WebSocket.send (currentColorJson model) id -- send current color to new client
        )

        WebSocketMsg (WebSocket.Disconnected id) -> (
            removeClient model id, 
            Cmd.none
        )

        WebSocketMsg (WebSocket.Message id hueString) -> 
            let {s, v} = model
                -- retrieve the new hue
                newH = Result.withDefault 0 <| String.toInt hueString
            -- then propagate to UpdateColor
            in model |> update (UpdateColor newH s v (Just id))

        UpdateColor h s v src -> (
            { model | h = h, s = s, v = v },
            broadcast (currentColorJson model) src model.clients
        )