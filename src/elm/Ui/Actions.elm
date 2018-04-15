module Ui.Actions exposing (
    Action(..), 
    SocketMessage(..), 
    socketMessageDecoder
    )

import Window exposing (Size)
import Collage exposing (Point)

import Json.Decode exposing (Decoder, oneOf, field, int, map, map3)

type Action
    = SetHue Int | SetValue Int
    | SocketMessage String
    | Resize Size
    | DragStart Point | DragAt Point Point | DragEnd Point

type SocketMessage 
    = Color Int Int Int -- h s l

socketMessageDecoder : Decoder SocketMessage
socketMessageDecoder = oneOf [
    hsvDecoder
    ]

hsvDecoder : Decoder SocketMessage
hsvDecoder = map3 Color (field "h" int) (field "s" int) (field "v" int)
