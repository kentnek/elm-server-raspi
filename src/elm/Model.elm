module Model exposing (Model, initial)

import Color exposing (Color, rgb)
import Window exposing (Size)

type alias Model = { 
    h: Int,
    s: Int, 
    v: Int, 
    windowSize: Size,
    dragging: Bool
}

initial : Model
initial = { 
    h = 0, s = 0, v = 50, 
    windowSize = Size 0 0, dragging = False
    } 