module Api.Model exposing (
    Model, initial, addClient, removeClient, filterClients,
    currentColorJson, writeColor
    )

import Json.Encode exposing (..)
import Server.WebSocket as WebSocket
import Api.Raspi as Raspi

import Color exposing (Color, toRgb)

type alias Model = { 
    clients: List WebSocket.Id,
    h: Int, s: Int, v: Int,
    rainbow: Bool
}

initial : Model
initial = { 
    clients = [],
    h = 0, s = 60, v = 100,
    rainbow = False
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

writeColorChannel : String -> Int -> Cmd msg 
writeColorChannel name byte = Raspi.writePwm name (1 - (toFloat byte) / 255)

writeColor : Color -> Cmd msg 
writeColor color = 
    let {red, green, blue} = color |> toRgb
    in Cmd.batch [
        writeColorChannel "r" red,
        writeColorChannel "g" green,
        writeColorChannel "b" blue
    ]
    
