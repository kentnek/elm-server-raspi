module Ui.Main exposing (..)

import Html
import Task exposing (Task)
import Window exposing (resizes)
import WebSocket exposing (listen)

import Ui.Actions exposing (Action(..))
import Ui.Model exposing (Model, initial)
import Ui.Config exposing (config)
import Ui.Update
import Ui.View


subscriptions : Model -> Sub Action
subscriptions model = 
    Sub.batch [
        resizes Resize,
        listen config.websocketUrl SocketMessage
    ]


main : Program Never Model Action
main =
    Html.program { 
        init = (Ui.Model.initial, Task.perform Resize Window.size), 
        update = Ui.Update.update,
        view = Ui.View.view, 
        subscriptions = subscriptions
    }
