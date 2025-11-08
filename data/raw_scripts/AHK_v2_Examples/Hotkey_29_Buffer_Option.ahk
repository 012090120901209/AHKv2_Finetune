#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Buffering Hotkey Presses
 * Control whether keypresses are buffered during Send
 */

; By default, hotkeys are buffered (B0 = no buffer, B1 = buffer)
; Using Hotkey() function to set buffer option
Hotkey("F6", BufferedAction, "B1")  ; B1 = buffered (default)
Hotkey("F7", UnbufferedAction, "B0") ; B0 = not buffered

BufferedAction(*) {
    MsgBox("F6 (Buffered)`n`nIf you press F6 again during this message,`nit will trigger again after you close this.", , "T3")
}

UnbufferedAction(*) {
    MsgBox("F7 (Unbuffered)`n`nIf you press F7 during this message,`nit will be ignored.", , "T3")
}

; Test: Press F6 or F7, then press it again quickly before closing MsgBox
