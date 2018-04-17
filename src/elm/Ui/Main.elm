module Ui.Main exposing (..)

import Html
import Task exposing (Task)
import Window exposing (resizes)
import WebSocket exposing (listen)

import Ui.Actions exposing (Action(..))
import Ui.Model exposing (Model, initial)
import Ui.Config exposing (Config)
import Ui.Update
import Ui.View

subscriptions : Model -> Sub Action
subscriptions model = 
    Sub.batch [
        resizes Resize,
        listen model.wsUrl SocketMessage
    ]

injectConfig : Config -> (Model, Cmd Action)
injectConfig { wsUrl, hostname } = (
    { initial | wsUrl = wsUrl, hostname = hostname },
    Task.perform Resize Window.size
    )
    

main : Program Config Model Action
main =
    Html.programWithFlags { 
        init = injectConfig, 
        update = Ui.Update.update,
        view = Ui.View.view, 
        subscriptions = subscriptions
    }
