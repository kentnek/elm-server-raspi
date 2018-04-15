module Ui.View exposing (view)

import Html exposing (..)
import Html.Attributes as H exposing (..)

import Ui.Model exposing (Model)
import Ui.Actions exposing (Action(..))
import Ui.Components.ColorWheel as ColorWheel


view : Model -> Html Action
view model =
    div [
        style [
            -- disable browsers scroll/pinch/... touch behaviors.
            ("touch-action", "none"),
            ("background", "black"),
            ("height", "100vh"),
            ("color", "white")
        ]
    ] [   
        ColorWheel.display model,
        div [
            style [
               ("text-align", "center")
            ]
        ] [
            h1 [] [text "Elm IoT Demo"],
            h2 [] [
                text "Connect to ",
                span [ class "code" ] [text "Elm-IoT-Demo"]
            ]
        ]

    ]

stringToIntAction : String -> Int
stringToIntAction string = Result.withDefault 0 <| String.toInt string