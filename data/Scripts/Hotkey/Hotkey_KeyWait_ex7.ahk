#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Mouse and Keyboard/KeyWait_ex7.ah2

~RControl::
{
    ; Added opening brace for [~RControl]
    global ; Made function global
    if (A_PriorHotkey != "~RControl" or A_TimeSincePriorHotkey > 400) { ; Too much time between presses, so this isn't a double-press. KeyWait("RControl")
    }
    MsgBox("You double-pressed the right control key.")
} ; Added closing brace for [~RControl]

