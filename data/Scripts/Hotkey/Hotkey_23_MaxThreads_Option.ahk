#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * MaxThreads Hotkey Option
 * Control how many instances of a hotkey can run simultaneously
 */

; Allow up to 3 simultaneous instances of this hotkey
Hotkey("F10", SlowFunction, "T3")  ; T3 = MaxThreads 3

SlowFunction(*) {
    static counter := 0
    counter++
    thisInstance := counter

    MsgBox("Instance " thisInstance " started`n`nPress F10 rapidly to see multiple instances", , "T2")
    Sleep(5000)
    ToolTip("Instance " thisInstance " finished")
    Sleep(1000)
    ToolTip()
}

; Default is MaxThreads 1 (only one instance at a time)
F11:: {
    MsgBox("Starting slow operation...", , "T1")
    Sleep(5000)
    MsgBox("Finished! (Try pressing F11 during the sleep)")
}
