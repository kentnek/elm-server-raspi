module Api.Main exposing (main)

import Platform exposing (Program)
import Task
import Api.Lib.RaspberryPi as Raspi

import Api.Model exposing (Model, initial)
import Api.Messages exposing (Message(Init))
import Api.Update exposing (update)
import Api.Subscriptions exposing (subscriptions)


initPins : List (Cmd Message)
initPins = [
        Raspi.declarePwm "r" "GPIO17",
        Raspi.declarePwm "g" "GPIO27",
        Raspi.declarePwm "b" "GPIO22",
        Raspi.declareButton "button" "GPIO10",
        Raspi.declareRotary "hue" "GPIO9" "GPIO11",
        perform Init
    ]

perform : msg -> Cmd msg
perform msg = Task.succeed msg |> Task.perform identity

main : Program Never Model Message
main = 
    Platform.program { 
        init = initial ! initPins,
        update = update,
        subscriptions = subscriptions
    }