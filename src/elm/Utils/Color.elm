module Utils.Color exposing (hsvToColor)

import Color exposing (Color, rgb)

hsvToColor : Int -> Int -> Int -> Color
hsvToColor hue sat value = 
    let h = (toFloat hue) / 60
        i = floor h |> toFloat
        s = (toFloat sat) / 100
        vv = (toFloat value) * 255 / 100
        f = h - i 
        p = vv*(1-s)|> floor
        q = vv*(1-f*s) |> floor
        t = vv*(1-(1-f)*s) |> floor
        v = floor vv
    in case (floor h) % 6 of
        0 -> rgb v t p
        1 -> rgb q v p
        2 -> rgb p v t
        3 -> rgb p q v
        4 -> rgb t p v
        5 -> rgb v p q   
        _ -> rgb 0 0 0