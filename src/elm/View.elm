module View exposing (view)

import Html exposing (Html, div, text, input, br)
import Html.Attributes as H exposing (..)
import Html.Events exposing (on, onInput)

import Model exposing (Model, toHex)
import Actions exposing (Action(..))
import Components.ColorWheel 

view : Model -> Html Action
view model =
    div [
        -- style [
        --    ("backgroundColor", "black"),
        --    ("color", "white"),
        --    ("height", "100vh")
        -- ]
    ] [   
        Components.ColorWheel.display model,
        br [] [],
        input [ 
            type_ "range", 
            H.min "0", 
            H.max "360", 
            value <| toString model.h,
            onInput HueSlider 
        ] [],
        br [] [],
        input [ 
            type_ "range", 
            H.min "0", 
            H.max "100", 
            value <| toString model.l,
            onInput LightSlider
        ] []
    ]
