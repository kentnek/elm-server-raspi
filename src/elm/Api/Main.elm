module Api.Main exposing (main)

import Platform exposing (Program)
import Api.Raspi as Raspi

import Api.Model exposing (..)
import Api.Messages exposing (Message(..))
import Api.Update exposing (update)
import Api.Subscriptions exposing (subscriptions)

import Task

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