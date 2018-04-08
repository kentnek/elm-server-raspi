module Actions exposing (Action(..))

import Window exposing (Size)
import Collage exposing (Point)

type Action
    = HueSlider String | LightSlider String
    | SetHue Int | SetLight Int
    | SocketMessage String
    | Resize Size
    | DragStart Point | DragAt Point Point | DragEnd Point
