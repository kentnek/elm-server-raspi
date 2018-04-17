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
            ("background", "black"),
            ("height", "100vh"),
            ("color", "white")
        ]
    ] [   
        div [
            -- disable browsers scroll/pinch/... touch behaviors.
            style [ ("touch-action", "none") ]
        ] [ ColorWheel.display model ],
        
        div [
            style [
               ("text-align", "center")
            ]
        ] [
            h1 [] [text "Elm IoT Demo"],
            h3 [] [
                div [ style [ ("margin-bottom", "8px") ] ] [
                    text "wifi: ",
                    span [ class "code" ] [text "notNUS"]
                ],
                div [ style [ ("margin-bottom", "8px") ] ] [
                    text "pass: ",
                    span [ class "code" ] [text "helloelm"]
                ],
                div [] [
                    text "url: ",
                    span [ class "code" ] [text model.hostname]
                ]
            ]
        ]
    ]
