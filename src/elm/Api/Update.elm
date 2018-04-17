module Api.Update exposing (update)

import Server.WebSocket as WebSocket
import Color exposing (Color, toRgb)

import Api.Model exposing (..)
import Api.Messages exposing (Message(..))
import Api.Lib.RaspberryPi exposing (..)

import Utils.Color exposing (hsvToColor)


update : Message -> Model -> (Model, Cmd Message)
update msg ({h, s, v} as model) =
    case msg of
        Init -> -- Update LED color on init
            (model, writeColor <| hsvToColor h s v)

        Ws (WebSocket.Connected id) -> ( -- new connected client
            addClient model id, -- append client
            WebSocket.send (currentColorJson model) id -- send current color to new client
        )

        Ws (WebSocket.Disconnected id) -> ( -- a client disconnected
            removeClient model id, 
            Cmd.none
        )

        Ws (WebSocket.Message id hueString) -> -- receives new hue from client            
            let newH = Result.withDefault 0 <| String.toInt hueString
            in model |> update (UpdateColor newH s v (Just id))

        Raspi (Rotary "hue" event) -> -- physical knob is rotated
            if (not model.rainbow) then
                let delta = if event == Increment then 2 else -2
                    newH = (h + delta) % 360
                in model |> update (UpdateColor newH s v Nothing)
            else (model, Cmd.none)

        -- Raspi (Button "button" value) -> 
        --     let _ = Debug.log "button" value
        --     in (model, Cmd.none)

        Raspi (Button "button" True) -> -- physical button is pressed
            ({ model | rainbow = not model.rainbow }, Cmd.none)

        RainbowTick _ -> -- Rainbow mode, onTick
            model |> update (UpdateColor ((h + 2) % 360) s v Nothing)
           
        UpdateColor h s v src -> -- request to update color
            { model | h = h, s = s, v = v } ! [
                -- write color to LEDs
                writeColor <| hsvToColor h s v,
                -- broadcast to all clients, except src of request
                broadcast (currentColorJson model) src model.clients 
            ]

        InternalError reason ->
            let _ = Debug.log "Internal error" reason
            in (model, Cmd.none)

        _ -> (model, Cmd.none)

-- Broadcast a message to all clients, except for the sender (if present)
broadcast : String -> Maybe WebSocket.Id -> List WebSocket.Id -> Cmd msg
broadcast message sender clients =
    let targets = 
        case sender of
            Nothing -> clients
            Just s -> filterClients clients s 
    in Cmd.batch <| List.map (\c -> WebSocket.send message c) clients

-- Update color channel with value byte
writeColorChannel : String -> Int -> Cmd msg 
writeColorChannel name byte = writePwm name (1 - (toFloat byte) / 255)

-- Update all 3 color channels, red, green & blue
writeColor : Color -> Cmd msg 
writeColor color = 
    let {red, green, blue} = color |> toRgb
    in Cmd.batch [
        writeColorChannel "r" red,
        writeColorChannel "g" green,
        writeColorChannel "b" blue
    ]
    

