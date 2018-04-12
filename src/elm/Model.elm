module Model exposing (Model, initial, toColor, toHex)

import Color exposing (Color, hsl)
import Color.Convert exposing (colorToHex)
import Window exposing (Size)


type alias Model = { 
    h: Int,
    s: Int, 
    l: Int, 
    windowSize: Size,
    dragging: Bool
}

initial : Model
initial = { 
    h = 0, s = 0, l = 50, 
    windowSize = Size 0 0, dragging = False
    } 

toColor : Model -> Color
toColor {h, s, l} = hsl (degrees <| toFloat h) ((toFloat s) / 100) ((toFloat l) / 100)

toHex : Model -> String 
toHex model = colorToHex <| toColor model