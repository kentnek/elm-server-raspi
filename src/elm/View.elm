module View exposing (view)

import Html exposing (Html, div, text, input, br)
import Html.Attributes as H exposing (..)
import Html.Events exposing (on, onInput)

import Model exposing (Model)
import Actions exposing (Action(..))
import Components.ColorWheel as ColorWheel


view : Model -> Html Action
view model =
    div [
        style [
            -- disable browsers scroll/pinch/... touch behaviors.
            ("touch-action", "none") 
        ]
    ] [   
        ColorWheel.display model,
        br [] [],
        input [ 
            type_ "range", 
            H.min "0", 
            H.max "360", 
            value <| toString model.h,
            onInput (SetHue << stringToIntAction)
        ] [],
        br [] [],
        input [ 
            type_ "range", 
            H.min "0", 
            H.max "100", 
            value <| toString model.v,
            onInput (SetValue << stringToIntAction)
        ] []
    ]

stringToIntAction : String -> Int
stringToIntAction string = Result.withDefault 0 <| String.toInt string