module Api.Model exposing (
    Model, initial, addClient, removeClient, filterClients,
    currentColorJson
    )

import Json.Encode exposing (..)
import Server.WebSocket as WebSocket

type alias Model = { 
    clients: List WebSocket.Id,
    h: Int, s: Int, v: Int
}

initial : Model
initial = { 
    clients = [],
    h = 100, s = 60, v = 100 
    } 

addClient : Model -> WebSocket.Id -> Model
addClient model toAdd = { model | clients = toAdd :: model.clients }

filterClients : List WebSocket.Id -> WebSocket.Id -> List WebSocket.Id
filterClients clients toFilterOut = List.filter (not << WebSocket.sameId toFilterOut) clients

removeClient : Model -> WebSocket.Id -> Model
removeClient model toRemove = 
    { model | clients = filterClients model.clients toRemove }

currentColorJson : Model -> String 
currentColorJson {h, s, v} = encode 0 
    <| object [ ("h", int h), ("s", int s), ("v", int v) ]