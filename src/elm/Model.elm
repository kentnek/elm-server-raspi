module Model exposing (Model, initial, toColor, toHex, hslDecoder)

import Color exposing (Color, hsl)
import Color.Convert exposing (colorToHex)

import Window exposing (Size)
import Json.Decode exposing (field, int, map3)

type alias HsvColor = {
    h: Int, -- 0->360
    s: Int, -- 0->100
    l: Int  -- 0->100
}

type alias Model = { 
    h: Int,
    s: Int, 
    l: Int, 
    size: Size,
    dragging: Bool
}

initial : Model
initial = { h = 0, s = 0, l = 0, size = Size 0 0, dragging = False } 

toColor : Model -> Color
toColor {h, s, l} = hsl (degrees <| toFloat h) ((toFloat s) / 100) ((toFloat l) / 100)

toHex : Model -> String 
toHex model = colorToHex <| toColor model

hslDecoder : Json.Decode.Decoder HsvColor
hslDecoder = map3 HsvColor (field "h" int) (field "s" int) (field "l" int)

