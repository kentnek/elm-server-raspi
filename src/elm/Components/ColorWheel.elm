module Components.ColorWheel exposing (display)

import Color exposing (..)
import Collage exposing (..)
import Collage.Events exposing (..)
import Collage.Layout exposing (..)
import Collage.Render exposing (..)

import Html exposing (Html)

-- import Json.Decode exposing (Decoder, int, field, float, map, map4, at)

import Model exposing (Model)
import Actions exposing (Action(..))


wheelSize : number
wheelSize = 300

display : Model -> Html Action
display model =
    let w = model.windowSize.width |> toFloat
        h = wheelSize |> toFloat |> (*) 1.5

        outerRadius = wheelSize / 2
        innerRadius = outerRadius * 0.9
        arrowRadius = outerRadius * 0.2
        touchRadius = outerRadius * 0.3
        arrowDistance = innerRadius - arrowRadius

        theta = model.h |> toFloat |> degrees
        arrowX = arrowDistance * sin(theta)
        arrowY = arrowDistance * cos(theta)

        color = hsvToRgb model.h model.s 60

        arrow = stack [
            ngon 3 arrowRadius |> filled (uniform color) |> rotate -theta,
            circle touchRadius |> filled (uniform (Color.rgba 0 0 0 0))
        ] |> shift (arrowX, arrowY)

        innerCircle = circle innerRadius |> filled (uniform black)
        outerCircle = circle outerRadius |> filled (uniform color)
        boundingBox = rectangle w h |> filled (uniform black)

        origin = (w/2, h/2)

        attachEvents collage = 
            case model.dragging of 
                True -> collage |> onPointerUp DragEnd |> onPointerMove (DragAt origin)
                False -> collage 

    in stack [
        arrow |> onPointerDown DragStart |> attachEvents,
        innerCircle |> attachEvents,
        outerCircle |> attachEvents,
        boundingBox |> attachEvents
    ] |> svg


hsvToRgb : Int -> Int -> Int -> Color
hsvToRgb hue sat value = 
    let h = (toFloat hue) / 60
        i = floor h |> toFloat
        s = (toFloat sat) / 100
        vv = (toFloat value) * 255 / 100
        f = h - i 
        p = vv*(1-s)|> floor
        q = vv*(1-f*s) |> floor
        t = vv*(1-(1-f)*s) |> floor
        v = floor vv
    in case (floor h) % 6 of
        0 -> rgb v t p
        1 -> rgb q v p
        2 -> rgb p v t
        3 -> rgb p q v
        4 -> rgb t p v
        5 -> rgb v p q   
        _ -> rgb 0 0 0