port module Api.Lib.RaspberryPi exposing (
    Event(..), RotaryMsg(..),
    listen,
    declarePwm, writePwm,
    declareRotary,
    declareButton
    )

import Json.Decode as D exposing (Decoder)
import Json.Encode as E
import Result

-- Port to receive Json from JavaScript as subscriptions
port fromRaspi : (D.Value -> msg) -> Sub msg

-- Port to send Json to JavaScript as commands
port toRaspi : E.Value -> Cmd msg

{- 
    Event
-}

type Event =
    Rotary String RotaryMsg 
    | Button String Bool

type RotaryMsg = Increment | Decrement

        
eventDecoder : Decoder Event
eventDecoder = D.oneOf [
    rotaryJsonDecoder,
    buttonJsonDecoder,
    errorJsonDecoder,
    D.fail "Unknown json"
    ]

listen : (Result String Event -> msg) -> Sub msg 
listen msg =
    fromRaspi (msg << D.decodeValue eventDecoder)

errorJsonDecoder : Decoder Event 
errorJsonDecoder = D.field "error" D.string |> D.andThen D.fail

{- 
    PWM pins
-}

declarePwm : String -> String -> Cmd msg 
declarePwm pwmName pin = toRaspi <|
    E.object [
        ("command", E.string "declare"),
        ("type", E.string "pwm"),
        ("name", E.string pwmName),
        ("pin", E.string pin)
    ]

writePwm : String -> Float -> Cmd msg 
writePwm name dutyCycle = toRaspi <| 
    E.object [ 
        ("command", E.string "write"),
        ("type", E.string "pwm"),
        ("name", E.string name), 
        ("dutyCycle", E.float dutyCycle)
    ]

{-
    Rotary Encoders.
    A rotary encoder, also called a shaft encoder, is an electro-mechanical device that converts 
    the angular position or motion of a shaft or axle to an analog or digital signal. 
    Not to be confused with Json Encoder :)
-}

declareRotary : String -> String -> String -> Cmd msg 
declareRotary rotaryName pinA pinB = toRaspi <|
    E.object [
        ("command", E.string "declare"),
        ("type", E.string "rotary"),
        ("name", E.string rotaryName),
        ("pinA", E.string pinA),
        ("pinB", E.string pinB)
    ]

{-
    Decode the following JSON:
        {
            rotary: <name>,
            action: "increment|decrement"
        }
    to the respective RotaryMsg.
-}
rotaryJsonDecoder : Decoder Event
rotaryJsonDecoder = 
    D.map2 Rotary 
        (D.field "rotary" D.string)
        (D.field "action" D.string |> D.andThen 
            (\action -> 
                case action of
                    "increment" -> D.succeed Increment 
                    "decrement" -> D.succeed Decrement 
                    _ -> D.fail <| "Unknown action for rotary: " ++ action
            )
        )

{-
    Push Button.
-}

declareButton : String -> String -> Cmd msg 
declareButton buttonName pin = toRaspi <|
    E.object [
        ("command", E.string "declare"),
        ("type", E.string "button"),
        ("name", E.string buttonName),
        ("pin", E.string pin)
    ]

{-
    Decode the following JSON:
        {
            push_button: <name>,
            value: true|false
        }
    to the respective RotaryMsg.
-}
buttonJsonDecoder : Decoder Event
buttonJsonDecoder = 
    D.map2 Button 
        (D.field "button" D.string)
        (D.field "value" D.bool)

    