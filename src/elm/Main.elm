module Main exposing (..)

import Html
import Task exposing (Task)
import Window exposing (resizes)
import WebSocket exposing (listen)

import Actions exposing (Action(..))
import Model exposing (Model, initial)
import Config exposing (config)
import Update
import View


subscriptions : Model -> Sub Action
subscriptions model = 
    Sub.batch [
        resizes Resize,
        listen config.websocketUrl SocketMessage
    ]


main : Program Never Model Action
main =
    Html.program { 
        init = (Model.initial, Task.perform Resize Window.size), 
        update = Update.update,
        view = View.view, 
        subscriptions = subscriptions
    }
