module Components.ColorWheel exposing (display)

import Color exposing (..)
import Collage exposing (..)
import Collage.Events exposing (..)
import Collage.Layout exposing (..)
import Collage.Render exposing (..)

import Html exposing (Html)

import Json.Decode exposing (Decoder, field, float, map, map2)

import Model exposing (Model, toColor)
import Actions exposing (Action(..))


wheelSize : number
wheelSize = 300

display : Model -> Html Action
display model =
    let w = model.size.width |> toFloat
        h = wheelSize |> toFloat |> (*) 1.5

        outerRadius = wheelSize / 2
        innerRadius = outerRadius * 0.9
        arrowRadius = outerRadius * 0.2
        arrowDistance = innerRadius - arrowRadius

        theta = model.h |> toFloat |> degrees
        arrowX = arrowDistance * sin(theta)
        arrowY = arrowDistance * cos(theta)

        color = toColor model

        arrow = ngon 3 arrowRadius |> filled (uniform color) |> rotate -theta |> shift (arrowX, arrowY)
        innerCircle = circle innerRadius |> filled (uniform black)
        outerCircle = circle outerRadius |> filled (uniform color)
        boundingBox = rectangle w h |> filled (uniform black)

        origin = (w/2, h/2)

        attachEvents collage = 
            case model.dragging of 
                True -> collage |> onUp DragEnd |> onMove (DragAt origin)
                False -> collage 

    in stack [
        arrow |> (onPointer "down") DragStart |> attachEvents,
        innerCircle |> attachEvents,
        outerCircle |> attachEvents,
        boundingBox |> attachEvents
    ] |> svg

-- Touch events

onPointer : String -> (Point -> msg) -> Collage msg -> Collage msg
onPointer event msg = on ("pointer" ++ event) <| map msg offsetDecoder

onDown : (Point -> msg) -> Collage msg -> Collage msg
onDown = onPointer "down"

onMove : (Point -> msg) -> Collage msg -> Collage msg
onMove = onPointer "move"

onUp : (Point -> msg) -> Collage msg -> Collage msg
onUp = onPointer "up"

offsetDecoder : Decoder Point
offsetDecoder =
    map2 (,)
        (field "clientX" float)
        (field "clientY" float)