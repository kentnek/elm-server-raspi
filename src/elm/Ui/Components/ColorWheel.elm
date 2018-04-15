module Ui.Components.ColorWheel exposing (display)

import Color exposing (..)
import Collage exposing (..)
import Collage.Events exposing (..)
import Collage.Layout exposing (..)
import Collage.Render exposing (..)
import Html exposing (Html)

-- import Json.Decode exposing (Decoder, int, field, float, map, map4, at)

import Ui.Model exposing (Model)
import Ui.Actions exposing (Action(..))
import Utils.Color exposing (hsvToRgb)


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